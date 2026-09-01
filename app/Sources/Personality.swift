import Foundation

/// Everything a character says in one language, plus how they sound saying it.
///
/// The two languages aren't translations of each other. Puns don't survive
/// translation, so the Arabic jokes are Arabic jokes; only the facts carry
/// across, because facts are facts.
struct SpeechPack {
    /// The character's name in this language.
    let name: String
    /// Preferred voice identifiers, best first.
    let voiceOrder: [String]
    /// Regional variants to fall back to, best first — "ar-SA" before "ar-001".
    let preferredLocales: [String]
    let pitch: Voice.Pitch
    let rate: Float
    /// Sung tonic in Hz.
    let singingRoot: Double

    let greetings: [String]
    let idle: [String]
    let poked: [String]
    let pokedAgain: [String]
    let dropped: [String]
    let leaving: [String]
    let welcomeBack: [String]
    let noticed: [String]
    let timeOfDay: [String]
    /// Keyed by `Personality.Bit.talk`.
    let byBit: [String: [String]]
    let jokes: [Joke]
    let facts: [String]
    let riddles: [Riddle]
    let twisters: [String]
    let songs: [Song]

    /// The voice this pack would like.
    ///
    /// A named voice wins if it's installed; otherwise the best regional match.
    /// That ordering means the app upgrades itself: macOS exposes only the
    /// world-Arabic voice today, but install a Saudi one and it gets picked up
    /// with no code change.
    ///
    /// A pack that can find no voice for its language returns nil, and the
    /// language isn't offered — reciting Arabic through an English synthesiser
    /// doesn't fail, it spells it out, unintelligibly.
    var preferredVoice: String? {
        for id in voiceOrder where Voice.installed(id) { return id }
        for locale in preferredLocales {
            if let match = Voice.bestVoice(forLocale: locale) { return match }
        }
        return nil
    }
}

/// Whether the system has a given voice installed.
func AVSpeechVoiceExists(_ identifier: String) -> Bool {
    Voice.installed(identifier)
}

/// Everything that makes one character not the other, independent of language:
/// how big they are, how they move, which clips they reach for, how often.
///
/// The two are deliberately opposed. Peedy is quick, fussy and theatrical —
/// lots of small movements. Bonzi is slow, heavy and unbothered, with a strong
/// preference for sitting down. Putting them on one desktop should feel like a
/// double act.
struct Personality {
    let id: String

    /// How a character makes itself understood.
    ///
    /// The Agent characters have mouth patches and a synthesiser. A game sprite
    /// rip has neither — no visemes, nothing to say — so it grunts, and the
    /// whole speech path simply doesn't apply to it.
    enum Expression {
        case speech
        case soundEffects
    }

    let expresses: Expression

    /// True for sprite rips from games, which are pixel art and must be scaled
    /// without smoothing.
    let pixelArt: Bool

    /// Scale relative to the sprite canvas, so the two end up sensibly sized
    /// next to each other rather than at whatever their sheets happened to be.
    let scale: CGFloat
    /// Seconds between idle beats, before energy and chattiness scale them.
    let beatRange: ClosedRange<Double>
    let travel: Travel
    let flourishes: [String]
    let bits: [Bit]

    /// What they say, per language. Empty for characters who don't talk.
    let packs: [Language: SpeechPack]

    enum Travel {
        /// Takeoff, a looping cruise, then a landing.
        case flies(takeoff: String, cruise: String, land: String)
        /// No takeoff or landing — just a clip to play while moving.
        case hops(cruise: String)

        var cruise: String {
            switch self {
            case .flies(_, let c, _), .hops(let c): return c
            }
        }
    }

    /// A "bit" is an intro, a loop to sit in, and an outro to undo it.
    struct Bit {
        let intro: String
        let loop: String?
        let outro: String?
        let hold: ClosedRange<Double>
        let talk: String            // key into SpeechPack.byBit
        /// Talk pose to lip-sync in, or nil when the sprite set has no mouth
        /// patches for this costume — they speak with a still mouth rather than
        /// snapping to a bare pose.
        let pose: String?
    }

    /// English is the fallback: every speaking character has it, and a
    /// half-translated character is worse than one that stays in a language it
    /// knows. Characters who don't speak return nil.
    func pack(_ language: Language) -> SpeechPack? {
        packs[language] ?? packs[.english]
    }

    var speaks: Bool { expresses == .speech }

    /// Languages this character can actually speak — a pack is only usable if
    /// the system has a voice for it. A silent character speaks all of them
    /// equally well, which is to say not at all, so it never constrains the
    /// choice.
    func languages() -> [Language] {
        guard speaks else { return Language.allCases }
        return Language.allCases.filter { packs[$0]?.preferredVoice != nil }
    }

    var name: String { pack(.english)?.name ?? id.capitalized }

    static let all: [Personality] = [.peedy, .bonzi, .axel]

    static func named(_ id: String) -> Personality {
        all.first { $0.id == id } ?? .peedy
    }
}
