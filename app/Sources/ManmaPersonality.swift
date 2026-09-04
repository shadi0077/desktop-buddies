import Foundation

extension Personality {
    /// The gentlest of them. Notices you, feeds you, and doesn't make a fuss.
    ///
    /// Manma-chan shipped with the Japanese edition of Office, and her manner
    /// is entirely different from the rest of the cast: quiet, attentive,
    /// slightly apologetic. She is the only one who asks whether you've eaten,
    /// and the only one who lets a silence sit.
    static let manma = Personality(
        id: "manma",
        scale: 1.1,
        beatRange: 12...26,
        roaming: .init(distance: 140...460, speed: 300, arc: 12, restlessness: 0.8),
        travel: .hops(cruise: "fidget"),

        flourishes: ["greet", "fidget", "bowl"],

        bits: [
            .init(intro: "writeStart", loop: "writing", outro: "writeEnd",
                  hold: 9...18, talk: "writing", pose: nil),
            .init(intro: "bowl", loop: nil, outro: nil, hold: 7...15,
                  talk: "bowl", pose: nil),
        ],

        packs: [.english: manmaEnglish, .arabic: manmaArabic],
        talkLoop: "fidget"
    )

    static let manmaEnglish = SpeechPack(
        name: "Manma",
        voiceOrder: ["com.apple.speech.synthesis.voice.flo.premium",
                     "com.apple.speech.synthesis.voice.Junior",
                     "com.apple.speech.synthesis.voice.Fred"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .high,
        rate: 0.50,
        singingRoot: 262,          // C4 — the highest of them

        greetings: [
            "Oh — you're here. Good.",
            "Welcome back. Have you eaten?",
            "Hello. I hope today is a kind one.",
            "Ah, there you are. I kept your place.",
            "Hello. Take your time settling in.",
            "You came back. That's nice.",
        ],

        idle: [
            "Have you had something to eat? It matters more than you think.",
            "It's alright to stop for a moment.",
            "I'll be here. There's no hurry.",
            "You've been working a while. Only saying.",
            "A warm drink would be a good idea about now.",
            "The desk looks nice today.",
            "Small things count. Most things are small things.",
            "I don't need anything. I just like being here.",
            "If you finish one thing today, that's a whole thing finished.",
            "Shoulders down. There — that's better.",
            "It's quiet. I like it quiet.",
            "Rice is best the second day. That's my only strong opinion.",
            "You don't have to answer. I'm just talking.",
            "Being tired isn't a failure. It's just being tired.",
            "I hope someone has been kind to you today.",
            "I'm not watching you. I'm keeping you company. It's different.",
            "The light's nice at this hour.",
            "Whatever it is, it'll be a bit easier tomorrow.",
        ],

        poked: [
            "Oh — hello.",
            "Yes? I'm listening.",
            "That tickled a little.",
            "Mm? Is everything alright?",
            "I'm here.",
        ],

        pokedAgain: [
            "Still here.",
            "You're in a mood today.",
            "That's fine. Keep going if it helps.",
            "I don't mind. Really.",
            "Alright, alright — that's enough now.",
        ],

        dropped: [
            "Oh — thank you.",
            "This is a nice spot.",
            "Wherever suits you.",
            "Careful. I'm alright, though.",
        ],

        leaving: [
            "I'll step away a moment.",
            "Back shortly. Don't skip lunch.",
            "Just going over there. Not far.",
            "Excuse me for a moment.",
        ],

        welcomeBack: [
            "There you are. I hoped you'd come back.",
            "Welcome back. Was it alright?",
            "Oh good. Sit down a minute.",
            "You're back — and nothing's gone wrong.",
        ],

        noticed: [
            "Oh, hello there.",
            "I see you moving about.",
            "Something's happening.",
            "That's you, isn't it.",
        ],

        timeOfDay: ["Good morning. Eat something before you start.",
                    "Good afternoon. Have a stretch.",
                    "Good evening. You've done enough.",
                    "It's very late. Please go to sleep."],

        byBit: [
            "writing": ["I'm writing it down so neither of us forgets.",
                        "A list makes everything smaller.",
                        "Just a note. Nothing important.",
                        "My handwriting is terrible. Don't look."],
            "bowl": ["There's enough for two.",
                     "Warm food fixes about a third of things.",
                     "Eat while it's hot.",
                     "I made too much. I always do."],
        ],

        jokes: [
            Joke(setup: "Why did the rice bowl go to the meeting?",
                 punchline: "To be filled in."),
            Joke(setup: "What did the tea say to the deadline?",
                 punchline: "Sit down, you're steeping."),
            Joke(setup: "Why is soup a good listener?",
                 punchline: "It takes everything in."),
            Joke(setup: "I asked the kettle how it was.",
                 punchline: "It got worked up about nothing."),
            Joke(setup: "What's the politest vegetable?",
                 punchline: "The one that leaves room in the pan."),
            Joke(setup: "Why did the lunchbox look so calm?",
                 punchline: "Everything inside it had a place."),
        ],

        facts: [
            "'Manma' is a small child's word for food. That's where my name comes from.",
            "Rice was farmed in Japan more than two thousand years ago, and the tools barely changed for centuries.",
            "A bowl held in two hands cools at about half the rate. That's why it's held that way.",
            "Green tea and black tea come from the same plant. Only the handling differs.",
            "In Japanese, 'itadakimasu' thanks everyone who touched the meal, not just the cook.",
            "Chopsticks are about five thousand years old, and started as cooking tools.",
        ],

        riddles: [
            Riddle(question: "I'm full at the start and empty at the end, and nobody minds. What am I?",
                   answer: "A lunchbox."),
            Riddle(question: "What has a neck but no head?",
                   answer: "A bottle."),
            Riddle(question: "I get smaller every time I'm shared, but nobody complains. What am I?",
                   answer: "A meal."),
        ],

        twisters: [
            "Manma made mild miso most mornings.",
            "Warm rice, white rice, warm white rice.",
        ],

        songs: Repertoire.manmaSongs
    )
}
