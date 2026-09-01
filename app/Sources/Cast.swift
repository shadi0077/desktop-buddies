import AppKit

/// One character, fully assembled: sprites, window, animator, brain, voice.
final class Buddy {
    let personality: Personality
    let store: SpriteStore
    let window: BuddyWindow
    let animator: Animator
    let brain: Brain

    init?(personality: Personality, language: Language, scale: CGFloat) {
        guard let store = SpriteStore(character: personality.id) else { return nil }
        self.personality = personality
        self.store = store
        window = BuddyWindow(store: store, scale: scale * personality.scale)
        window.buddyView.pixelArt = personality.pixelArt
        animator = Animator(store: store, view: window.buddyView)
        brain = Brain(personality: personality, language: language, store: store,
                      animator: animator, window: window)
        store.warm(["rest", "arrive", personality.travel.cruise, "greet", "blink"])
    }

    var id: String { personality.id }
    var isVisible: Bool { brain.isVisible }

    func start() { animator.start() }
    func stop() { animator.stop() }
}

/// Who is on screen, and what happens when there is more than one of them.
final class Cast {
    private(set) var buddies: [Buddy] = []
    private var timer: Timer?

    /// True while an exchange is running, so nothing else grabs them.
    private(set) var talking = false
    private var nextBanter = Date().addingTimeInterval(35)
    private var recentBanter = RecentPicks(limit: 6)

    var chattiness: Chattiness = .occasional {
        didSet { buddies.forEach { $0.brain.chattiness = chattiness } }
    }

    private(set) var language: Language

    init(language: Language, scale: CGFloat) {
        self.language = language
        for personality in Personality.all {
            if let buddy = Buddy(personality: personality, language: language, scale: scale) {
                buddies.append(buddy)
            }
        }
        buddies.forEach { $0.start() }

        // Nobody starts a line while somebody else is finishing one.
        for buddy in buddies {
            // Strictly "is somebody else mid-sentence". It must stay true for
            // whoever currently holds the floor, or a character delivering a
            // banter line would block on himself.
            buddy.brain.mayStartTalking = { [weak self, weak buddy] in
                guard let self, let buddy else { return true }
                return !self.onScreen.contains {
                    $0.id != buddy.id && $0.brain.isSpeakingNow
                }
            }
        }

        // One slow tick is plenty; the characters run their own 60 Hz clocks.
        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in self?.tick() }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func buddy(_ id: String) -> Buddy? { buddies.first { $0.id == id } }

    /// Switch everyone over at once — a bilingual pair would be odd.
    func speak(_ language: Language) {
        guard language != self.language else { return }
        self.language = language
        talking = false
        buddies.forEach { $0.brain.speak(language) }
    }

    /// Languages every character on screen can actually speak. A language with
    /// no installed voice isn't offered at all.
    var availableLanguages: [Language] {
        // A character who doesn't speak never rules a language out.
        Language.allCases.filter { language in
            buddies.allSatisfy {
                !$0.personality.speaks
                    || $0.personality.packs[language]?.preferredVoice != nil
            }
        }
    }
    var onScreen: [Buddy] { buddies.filter(\.isVisible) }
    var activeIDs: Set<String> { Set(onScreen.map(\.id)) }

    // MARK: - Coming and going

    func show(_ id: String, at point: NSPoint? = nil) {
        guard let buddy = buddy(id), !buddy.isVisible else { return }
        buddy.brain.appear(at: point ?? spot(for: buddy))
    }

    /// Bring several on, staggered — arriving together means greeting together,
    /// and two voices at once is just noise.
    func showAll(_ ids: [String], savedOrigin: @escaping (String) -> NSPoint?) {
        for (n, id) in ids.enumerated() {
            let delay = Double(n) * 3.5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.show(id, at: savedOrigin(id))
            }
        }
    }

    func hide(_ id: String) {
        buddy(id)?.brain.vanish()
    }

    /// A starting position that doesn't land on top of whoever is already out.
    private func spot(for buddy: Buddy) -> NSPoint {
        guard let screen = NSScreen.main else { return .zero }
        let vf = screen.visibleFrame
        let size = buddy.window.frame.size
        let taken = onScreen.filter { $0.id != buddy.id }.map(\.window.frame)

        // Try a few slots along the bottom, right to left, and take the first
        // that isn't already occupied.
        for slot in 0..<4 {
            let x = vf.maxX - size.width - 60 - CGFloat(slot) * (size.width + 70)
            let candidate = NSRect(x: max(x, vf.minX + 8), y: vf.minY + 40,
                                   width: size.width, height: size.height)
            if !taken.contains(where: { $0.intersects(candidate.insetBy(dx: -30, dy: -30)) }) {
                return candidate.origin
            }
        }
        return NSPoint(x: vf.midX - size.width / 2, y: vf.minY + 40)
    }

    // MARK: - Them talking to each other

    private func tick() {
        guard !talking, Date() >= nextBanter else { return }
        let present = onScreen
        guard present.count > 1 else {
            nextBanter = Date().addingTimeInterval(20)
            return
        }
        guard present.allSatisfy({ $0.brain.isAvailable }) else { return }
        startBanter()
    }

    /// Kick off an exchange now, if the cast allows one.
    @discardableResult
    func startBanter() -> Bool {
        guard !talking else { return false }
        let present = onScreen
        guard present.count > 1, present.allSatisfy({ $0.brain.isAvailable }) else { return false }

        let options = Banter.available(for: activeIDs, in: language)
        guard !options.isEmpty else { return false }

        // Pick by opening line so the no-repeat memory has something stable to
        // key on.
        let opener = recentBanter.pick(from: options.map { $0[0].text })
        guard let exchange = options.first(where: { $0[0].text == opener }) else { return false }

        talking = true
        plog("banter: \(exchange.count) lines, opening \"\(opener)\"")
        // Long enough that neither wanders off mid-conversation.
        let hold = Double(exchange.count) * 6 + 6
        present.forEach { $0.brain.holdBeats(for: hold) }
        deliver(exchange, at: 0)
        return true
    }

    private func deliver(_ exchange: [BanterLine], at index: Int) {
        guard index < exchange.count else {
            talking = false
            nextBanter = Date().addingTimeInterval(Double.random(in: 50...110))
            return
        }
        let line = exchange[index]
        guard let speaker = buddy(line.who), speaker.isVisible else {
            deliver(exchange, at: index + 1)
            return
        }
        // Anyone else on screen is who he's talking to.
        let other = onScreen.first { $0.id != speaker.id }

        speaker.brain.deliver(line.text, move: line.move,
                              facing: other?.brain.centreX) { [weak self] in
            guard let self, self.talking else { return }
            // A beat between lines, so it reads as conversation rather than a
            // pair of monologues.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.deliver(exchange, at: index + 1)
            }
        }
    }

    /// Bring them together, then have them talk.
    func gatherAndBanter() {
        let present = onScreen
        guard present.count > 1, !talking else {
            startBanter()
            return
        }
        guard let first = present.first, let second = present.dropFirst().first else { return }
        let apart = abs(first.brain.centreX - second.brain.centreX)
        guard apart > second.window.frame.width * 1.6 else { startBanter(); return }
        second.brain.moveNear(x: first.brain.centreX) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { self?.startBanter() }
        }
    }

    func clampAll() { buddies.forEach { $0.brain.clampToScreen() } }

    func resize(to scale: CGFloat) {
        for buddy in buddies {
            buddy.window.resize(to: scale * buddy.personality.scale, store: buddy.store)
            buddy.brain.clampToScreen()
        }
    }
}
