import Foundation

/// The rest of the Streets of Rage 2 roster.
///
/// All four share one sound set — it's one game's rip — and differ the way the
/// characters do: Blaze is quick and acrobatic, Max is heavy and slow, Skate is
/// on rollerblades and never stops moving.
extension Personality {
    static let blaze = Personality(
        id: "blaze",
        expresses: .soundEffects,
        pixelArt: true,
        soundSet: "_sor2",
        scale: 1.55,
        beatRange: 6...14,
        roaming: .init(distance: 600...2200, speed: 190, arc: 0, restlessness: 2.6),
        travel: .hops(cruise: "walk"),
        flourishes: ["punch", "kick", "highKick", "flip", "projectile", "spin"],
        bits: [
            .init(intro: "flip", loop: nil, outro: nil, hold: 0...0, talk: "flip", pose: nil),
            .init(intro: "projectile", loop: nil, outro: nil, hold: 0...0,
                  talk: "projectile", pose: nil),
            .init(intro: "knockdown", loop: nil, outro: nil, hold: 0...0,
                  talk: "down", pose: nil),
        ],
        packs: [:]
    )

    static let max = Personality(
        id: "max",
        expresses: .soundEffects,
        pixelArt: true,
        soundSet: "_sor2",
        scale: 1.55,
        beatRange: 11...24,        // he is not a quick man
        roaming: .init(distance: 500...1600, speed: 120, arc: 0, restlessness: 1.6),
        travel: .hops(cruise: "walk"),
        flourishes: ["punch", "flex", "grapple", "slam"],
        bits: [
            .init(intro: "flex", loop: nil, outro: nil, hold: 0...0, talk: "flex", pose: nil),
            .init(intro: "grapple", loop: nil, outro: "slam", hold: 0...0,
                  talk: "grapple", pose: nil),
            .init(intro: "knockdown", loop: nil, outro: nil, hold: 0...0,
                  talk: "down", pose: nil),
        ],
        packs: [:]
    )

    static let skate = Personality(
        id: "skate",
        expresses: .soundEffects,
        pixelArt: true,
        soundSet: "_sor2",
        scale: 1.55,
        beatRange: 5...11,         // a teenager on rollerblades
        roaming: .init(distance: 900...3000, speed: 300, arc: 0, restlessness: 3.4),
        travel: .hops(cruise: "walk"),
        flourishes: ["punch", "kick", "flip", "spin", "dash"],
        bits: [
            .init(intro: "dash", loop: nil, outro: nil, hold: 0...0, talk: "dash", pose: nil),
            .init(intro: "spin", loop: nil, outro: nil, hold: 0...0, talk: "spin", pose: nil),
            .init(intro: "knockdown", loop: nil, outro: nil, hold: 0...0,
                  talk: "down", pose: nil),
        ],
        packs: [:]
    )
}
