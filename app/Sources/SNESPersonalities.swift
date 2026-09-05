import Foundation

/// The SNES shelf: twenty characters out of sixteen games.
///
/// The Mega Drive cast came off four sheets in one layout and could share
/// almost everything. This one shares nothing but the console, and the
/// differences that matter are physical rather than stylistic:
///
/// **They are not the same size.** Mario's idle sprite is 20 pixels tall and
/// Guy's is 87, a factor of four. Scaled by one number, either Mario is under a
/// centimetre or Guy fills a quarter of the screen, so `scale` is set per
/// character to a target height rather than to a shared multiplier. The
/// relative order is kept — Kirby small, Donkey Kong big — but the extremes are
/// pulled in, because a desktop is not a diorama and Mario still has to be
/// clickable.
///
/// **Three of them have no walk.** Squawks flies, the last Metroid floats, and
/// Jim, out of his suit, is a worm and squirms. The Metroid is the only one
/// besides the parrot that travels on an arc.
///
/// **Their idles disagree about where the viewer is.** The platformer rips
/// stand in profile; the beat-'em-up rips — the Turtles, Guy, and Pac-Man —
/// stand square to camera, because that is how the genre draws a fighting
/// stance. Samus was deliberately given a profile idle so she would not pivot
/// ninety degrees the moment she set off, but four Turtles facing front
/// together read as a lineup rather than a mistake, so they were left alone.
///
/// None of them carries a sound set. There is no rip of these games' audio to
/// hand, and borrowing the Streets of Rage grunts for Nintendo's characters
/// would be worse than silence — the same reasoning that leaves the Mega Drive
/// cartoon characters quiet.
extension Personality {

    private static func snes(
        _ id: String, scale: CGFloat, beats: ClosedRange<Double>,
        speed: CGFloat, distance: ClosedRange<CGFloat>, restlessness: Double,
        arc: CGFloat = 0, travel: Travel? = nil, walk: String = "walk",
        flourishes: [String], bits: [Bit], title: String? = nil
    ) -> Personality {
        Personality(
            id: id, pixelArt: true, scale: scale, beatRange: beats,
            roaming: .init(distance: distance, speed: speed, arc: arc,
                           restlessness: restlessness),
            travel: travel ?? .hops(cruise: walk), flourishes: flourishes,
            bits: bits, title: title)
    }

    private static func moment(_ clip: String) -> Bit {
        .init(intro: clip, loop: nil, outro: nil, hold: 0...0)
    }

    // MARK: - Nintendo

    /// Two frames of walk and one of standing still. Super Mario World gave him
    /// almost nothing to idle with, which suits him: he waits perfectly still
    /// and then goes, fast.
    static let mario = snes("mario", scale: 4.2, beats: 6...13, speed: 220,
                            distance: 500...1800, restlessness: 2.6,
                            flourishes: ["jump", "duck", "lookUp", "victory", "run"],
                            bits: [moment("victory"), moment("jump"), moment("lookUp")])

    /// The same sheet in the same order — but not at the same indices, which is
    /// the trap that caught this cast. See `victory` in catalog.py.
    static let luigi = snes("luigi", scale: 4.0, beats: 7...15, speed: 200,
                            distance: 500...1700, restlessness: 2.4,
                            flourishes: ["jump", "duck", "lookUp", "victory", "run"],
                            bits: [moment("victory"), moment("jump"), moment("duck")])

    /// He could travel two ways — he has a walk and four frames of puffed-up
    /// float — and walks, because as travel the float would put an inflate and
    /// a deflate on every crossing.
    static let kirby = snes("kirby", scale: 3.4, beats: 6...14, speed: 170,
                            distance: 400...1400, restlessness: 2.4,
                            flourishes: ["inhale", "jump", "shout", "squash", "float"],
                            bits: [moment("inhale"), moment("float"), moment("squash")])

    /// Deliberate, and heavier than she looks: four frames at ten a second,
    /// which reads as weight rather than sluggishness.
    static let samus = snes("samus", scale: 2.5, beats: 9...19, speed: 150,
                            distance: 500...1600, restlessness: 1.8,
                            flourishes: ["aimUp", "crouch", "stand"],
                            bits: [moment("stand"), moment("aimUp"), moment("crouch")])

    /// No legs, so no walk: it drifts, on an arc, slowly. The pulse is its idle
    /// and its travel both, which is exactly what a Metroid does.
    static let metroid = snes("metroid", scale: 1.6, beats: 12...26, speed: 90,
                              distance: 300...1100, restlessness: 1.4, arc: 26,
                              travel: .hops(cruise: "float"),
                              flourishes: ["flash", "float"],
                              bits: [moment("flash")], title: "Metroid")

    // MARK: - Rare

    /// The biggest sprite here and the slowest mover, on the reasoning that
    /// makes Max slow: a heavy character crossing quickly stops reading heavy.
    static let dk = snes("dk", scale: 3.2, beats: 11...24, speed: 130,
                         distance: 400...1300, restlessness: 1.4,
                         flourishes: ["chestBeat", "clap", "run"],
                         bits: [moment("chestBeat"), moment("clap")],
                         title: "Donkey Kong")

    /// The counterweight to Donkey Kong: never still, covers ground in bursts,
    /// cartwheels for no reason. The highest restlessness in the cast.
    static let diddy = snes("diddy", scale: 2.7, beats: 5...11, speed: 240,
                            distance: 700...2200, restlessness: 3.2,
                            flourishes: ["cartwheel", "jump"],
                            bits: [moment("cartwheel"), moment("jump")],
                            title: "Diddy Kong")

    /// Twelve frames of ponytail — the longest genuine idle loop of the twenty,
    /// so she is the one worth watching while she does nothing.
    static let dixie = snes("dixie", scale: 2.7, beats: 6...13, speed: 210,
                            distance: 600...2000, restlessness: 2.8,
                            flourishes: ["run", "jump"],
                            bits: [moment("jump"), moment("run")],
                            title: "Dixie Kong")

    /// The only one who flies, and the only one whose sheet gave a takeoff and
    /// a landing to fly with. Four frames of flap is his whole repertoire, so
    /// he spends his restlessness on crossings rather than tricks.
    static let squawks = snes("squawks", scale: 2.4, beats: 5...12, speed: 380,
                              distance: 300...1200, restlessness: 2.2, arc: 40,
                              travel: .flies(takeoff: "takeoff", cruise: "flap",
                                             land: "land"),
                              flourishes: ["flap"], bits: [moment("flap")])

    // MARK: - Capcom, Konami, Namco, Shiny

    /// The eight-frame cycle is a run in the game, not a walk, so he is paced as
    /// one. Playing a run at walking speed is the moonwalking problem from the
    /// other side — the feet going faster than the window.
    static let megamanx = snes("megamanx", scale: 2.8, beats: 6...13, speed: 260,
                               distance: 700...2400, restlessness: 3.0,
                               flourishes: ["dash", "shoot", "jump", "charge"],
                               bits: [moment("charge"), moment("shoot"), moment("dash")],
                               title: "Mega Man X")

    /// Super Castlevania IV. The Belmont walk is famously stiff, and it stays
    /// stiff here, at a speed that lets you see each of the six frames.
    static let simon = snes("simon", scale: 2.5, beats: 10...21, speed: 140,
                            distance: 400...1400, restlessness: 1.5,
                            flourishes: ["whip", "duck", "jump"],
                            bits: [moment("whip"), moment("duck")],
                            title: "Simon Belmont")

    /// Dracula X, seven years later and no quicker.
    static let richter = snes("richter", scale: 2.6, beats: 9...20, speed: 150,
                              distance: 400...1500, restlessness: 1.6,
                              flourishes: ["whip"], bits: [moment("whip")],
                              title: "Richter Belmont")

    /// Final Fight 3. A ninja, so the quickest walker here; the run is a
    /// separate cycle and stays a flourish, because at a run he crosses the
    /// screen faster than the eye follows.
    static let guy = snes("guy", scale: 1.3, beats: 6...13, speed: 250,
                          distance: 700...2300, restlessness: 2.8,
                          flourishes: ["run", "kick", "jumpKick"],
                          bits: [moment("kick"), moment("jumpKick")])

    /// Pac-Man 2. The only character here whose idle is simply a face looking
    /// at you, which for Pac-Man is the whole performance.
    static let pacman = snes("pacman", scale: 3.5, beats: 6...14, speed: 200,
                             distance: 500...1800, restlessness: 2.6,
                             flourishes: ["cheer"], bits: [moment("cheer")],
                             title: "Pac-Man")

    /// Earthworm Jim, SNES. The id carries the console: MegaDrive Buddies
    /// already has a `jim`, out of Earthworm Jim 2 — same character, different
    /// machine, different rip.
    static let ewj = snes("ewj", scale: 2.1, beats: 6...14, speed: 195,
                          distance: 600...2000, restlessness: 2.4,
                          flourishes: ["whip", "shoot", "jump"],
                          bits: [moment("shoot"), moment("whip"), moment("jump")],
                          title: "Earthworm Jim")

    /// The same worm with the suit off, from the other SNES rip. Slowest of the
    /// twenty: the crawl is eight frames of whole-body effort, and moving him
    /// at any pace makes the effort look free.
    static let jimworm = snes("jimworm", scale: 2.4, beats: 8...17, speed: 120,
                              distance: 300...1000, restlessness: 2.0,
                              walk: "squirm",
                              flourishes: ["jump", "spin", "squirm"],
                              bits: [moment("spin"), moment("jump")],
                              title: "Jim (No Suit)")

    // MARK: - Turtles in Time
    //
    // Four sheets, one game, and two different cutting settings between them —
    // see docs/SNES.md. Paced the way the cartoon casts them rather than by
    // anything in the sprites: Leonardo measured, Raphael short-tempered,
    // Michelangelo never still, Donatello slowest and least restless.
    //
    // The ids are short because the long ones are taken: MegaDrive Buddies has
    // the Hyperstone Heist four as `leonardo` and the rest. Two products, two
    // consoles, and they never appear on a desktop together.

    static let leo = snes("leo", scale: 2.0, beats: 8...17, speed: 175,
                          distance: 500...1700, restlessness: 2.0,
                          flourishes: ["jump", "roll", "attack"],
                          bits: [moment("attack"), moment("roll")], title: "Leonardo")

    static let raph = snes("raph", scale: 2.05, beats: 6...13, speed: 205,
                           distance: 600...2000, restlessness: 2.6,
                           flourishes: ["jump", "attack"],
                           bits: [moment("attack"), moment("jump")],
                           title: "Raphael")

    static let mikey = snes("mikey", scale: 2.0, beats: 5...12, speed: 215,
                            distance: 700...2200, restlessness: 3.0,
                            flourishes: ["swing", "flip"],
                            bits: [moment("flip"), moment("swing")],
                            title: "Michelangelo")

    static let donnie = snes("donnie", scale: 2.0, beats: 9...19, speed: 160,
                             distance: 400...1500, restlessness: 1.7,
                             flourishes: ["swing", "spin"],
                             bits: [moment("spin"), moment("swing")],
                             title: "Donatello")
}
