import Foundation

extension Personality {
    /// Axel Stone, Streets of Rage 2.
    ///
    /// A beat-'em-up sprite rip rather than a Microsoft Agent character, and it
    /// shows: no mouth frames, no visemes, nothing to say. He stands guard,
    /// walks, throws punches and a Grand Upper, and the game's own sound
    /// effects do the talking. Everything about the speech path — bubbles,
    /// lip sync, the pitch resynthesis — is simply not his.
    static let axel = Personality(
        id: "axel",
        expresses: .soundEffects,
        pixelArt: true,
        scale: 1.55,               // Genesis sprites are small; scale him up
        beatRange: 7...16,         // restless, the way someone squaring up is
        travel: .hops(cruise: "walk"),

        flourishes: ["punch", "jab", "kick", "highKick", "knee",
                     "grandUpper", "uppercut", "flameArc", "celebrate",
                     "guard", "stretch", "jumpKick"],

        // No costumes to put on and take off. His "bits" are combinations,
        // which is what a beat-'em-up character has instead.
        bits: [
            .init(intro: "guard", loop: nil, outro: "punch",
                  hold: 0...0, talk: "guard", pose: nil),
            .init(intro: "stretch", loop: nil, outro: nil,
                  hold: 0...0, talk: "stretch", pose: nil),
            .init(intro: "knockdown", loop: nil, outro: "getUp",
                  hold: 0...0, talk: "down", pose: nil),
        ],

        packs: [:]
    )
}
