import Foundation

/// Everything that makes one character not the other: how he sounds, what he
/// says, which clips he reaches for, and the bits of business he does.
///
/// The two are deliberately opposed. Peedy is quick, fussy and theatrical —
/// high voice, short sentences, lots of small movements. Bonzi is slow, heavy
/// and unbothered — low voice, long pauses, and a strong preference for sitting
/// down. Putting them on the same desktop should feel like a double act.
struct Personality {
    let id: String
    let name: String

    // How he sounds.
    let voiceOrder: [String]        // preferred voice identifiers, best first
    let pitch: Voice.Pitch
    let rate: Float
    /// Tonic for singing, in Hz. Independent of the speaking pitch: the sung
    /// pitch is imposed on the audio afterwards, not asked of the synthesiser.
    let singingRoot: Double

    // How he moves.
    /// Scale relative to the sprite canvas, so the two end up sensibly sized
    /// next to each other rather than at whatever their sheets happened to be.
    let scale: CGFloat
    /// Seconds between idle beats, before energy scales them.
    let beatRange: ClosedRange<Double>
    /// How he gets from one part of the screen to another.
    let travel: Travel

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

    // What he does.
    let flourishes: [String]
    let bits: [Bit]

    // What he says.
    let greetings: [String]
    let idle: [String]
    let poked: [String]
    let pokedAgain: [String]
    let dropped: [String]
    let leaving: [String]
    let welcomeBack: [String]
    let noticed: [String]
    let byBit: [String: [String]]
    let jokes: [Joke]
    let facts: [String]
    let twisters: [String]
    let songs: [Song]

    /// A "bit" is an intro, a loop to sit in, and an outro to undo it.
    struct Bit {
        let intro: String
        let loop: String?
        let outro: String?
        let hold: ClosedRange<Double>
        let talk: String            // key into byBit
        /// Talk pose to lip-sync in, or nil when the sprite set has no mouth
        /// patches for this costume — he speaks with a still mouth rather than
        /// snapping to a bare pose.
        let pose: String?
    }

    /// The voice he'd like, falling back through the list to whatever exists.
    var preferredVoice: String {
        for id in voiceOrder where Voice.options.contains(where: { $0.identifier == id }) {
            return id
        }
        return Voice.defaultIdentifier
    }

    static let all: [Personality] = [.peedy, .bonzi]

    static func named(_ id: String) -> Personality {
        all.first { $0.id == id } ?? .peedy
    }
}
