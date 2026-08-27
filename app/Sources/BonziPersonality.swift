import Foundation

extension Personality {
    /// Slow, heavy, unbothered. Where Peedy fires off ten short remarks a
    /// minute, Bonzi says one long one and then sits down. Low voice, unhurried
    /// rate, long gaps between beats. He likes bananas, gravity, and not
    /// rushing.
    static let bonzi = Personality(
        id: "bonzi",
        name: "Bonzi",
        // A different voice from Peedy's Fred, so they're never confusable.
        voiceOrder: ["com.apple.speech.synthesis.voice.Ralph",
                     "com.apple.eloquence.en-US.Grandpa",
                     "com.apple.speech.synthesis.voice.Fred"],
        pitch: .deep,
        rate: 0.44,
        singingRoot: 123,      // B2 — most of an octave below Peedy                 // noticeably slower than Peedy's 0.52
        scale: 1.0,                 // his canvas is already bigger than Peedy's
        beatRange: 14...32,         // and he does far less, far less often
        travel: .hops(cruise: "vineSwing"),

        flourishes: ["lookAround", "shrug", "scratchHead", "point",
                     "handsOnHips", "cheer", "greet", "announce", "vineSwing"],

        bits: [
            .init(intro: "readStart", loop: "reading", outro: "readEnd",
                  hold: 6...12, talk: "reading", pose: nil),
            .init(intro: "sitDown", loop: "sitting", outro: "standUp",
                  hold: 8...16, talk: "sitting", pose: nil),
            .init(intro: "headphonesOn", loop: "listening", outro: "headphonesOff",
                  hold: 6...12, talk: "listening", pose: nil),
            .init(intro: "sunglassesOn", loop: "sunglassesIdle", outro: "sunglassesOff",
                  hold: 4...9, talk: "sunglasses", pose: "sunglasses"),
            .init(intro: "eatBanana", loop: nil, outro: nil,
                  hold: 0...0, talk: "banana", pose: "banana"),
            .init(intro: "juggle", loop: nil, outro: nil,
                  hold: 0...0, talk: "juggling", pose: nil),
            .init(intro: "globe", loop: nil, outro: "globeEnd",
                  hold: 0...0, talk: "globe", pose: nil),
            .init(intro: "poof", loop: nil, outro: nil,
                  hold: 0...0, talk: "poof", pose: nil),
            .init(intro: "paper", loop: nil, outro: nil,
                  hold: 0...0, talk: "paper", pose: "paper"),
        ],

        greetings: [
            "Oh. Hello.",
            "There you are. I was in no hurry.",
            "Hi. I brought nothing.",
            "Morning. Or whenever this is.",
            "Hello. I've been thinking about a banana.",
            "Good. You're here. I had a thought and I've forgotten it.",
            "Hello, small person behind the glass.",
            "I have arrived. It took a while.",
        ],

        idle: [
            "I could sit down.",
            "Gravity's doing most of the work today.",
            "Big day. Well. Medium.",
            "I've been standing here for a bit. It's going well.",
            "Bananas are a berry, you know. Botanically. It bothers me.",
            "Nothing wrong with a slow afternoon.",
            "I'm not stuck. I'm considering.",
            "Have you noticed how much of life is just waiting for things?",
            "That's a lot of clicking.",
            "I'd help, but I'd only make it heavier.",
            "This is a nice bit of desktop. Solid.",
            "Ook. That's a real word where I'm from.",
            "You should eat something. I say that as a professional eater.",
            "One of my arms is slightly longer. Don't look for it.",
            "I like it here. Good ceiling height.",
            "In the wild I'd be asleep by now. In fairness, so would you.",
            "Everything's fine. I checked. Slowly.",
            "I've been told I have a calming presence. By me.",
            "Some days the best plan is a nap and a snack.",
            "I don't run. I've never needed to.",
            "Do you ever think about how tall trees are? I do. Often.",
            "Take your time. I'm extremely good at that.",
            "I could carry that for you. Whatever it is.",
            "Purple was not my choice, but I've grown into it.",
            "I had a plan this morning. It's gone now.",
        ],

        poked: [
            "Oof.",
            "Hello. That was firm.",
            "Yes? I'm right here. I'm always right here.",
            "You have my attention. Most of it.",
            "Careful, I'm mostly muscle and opinions.",
            "That's a poke. I know a poke.",
            "Mm?",
        ],

        pokedAgain: [
            "You've done that a few times now.",
            "I'm not going anywhere. You can stop checking.",
            "This is our thing now, apparently.",
            "Still here. Still purple.",
            "I could do this all day. That's not a boast, it's a warning.",
        ],

        dropped: [
            "Oof. Landed.",
            "Fine. Here's good too.",
            "I don't mind. I rarely mind.",
            "You could have asked. I'd have walked.",
            "New spot. Same me.",
        ],

        leaving: [
            "Right. I'm off.",
            "Going to find a tree.",
            "Back shortly. Or not shortly.",
            "I'll be around. Somewhere.",
        ],

        welcomeBack: [
            "Oh good. You.",
            "I didn't move. Not even once.",
            "Welcome back. Nothing happened, as usual.",
            "You were gone a while. I had a sit down.",
        ],

        noticed: [
            "I see that.",
            "That arrow's back.",
            "Hello, pointer.",
        ],

        byBit: [
            "reading": ["It's a long one. I'm on page four.",
                        "Books are heavy. That's the main thing about books.",
                        "I read slowly. On purpose."],
            "sitting": ["Ah. That's better.",
                        "I'm going to be here a while.",
                        "Sitting is underrated. Genuinely."],
            "listening": ["Good beat. Bit fast.",
                          "This is the one with the bit I like.",
                          "I mostly listen to the low notes."],
            "sunglasses": ["Yes.",
                           "Sun's bright. Even in here.",
                           "I look better in these. Objectively."],
            "banana": ["A banana. Every time.",
                       "This is the best part of the day.",
                       "I've eaten thousands of these. Still good."],
            "juggling": ["Coconuts. Don't ask where from.",
                         "Watch this. Or don't, it goes on a bit.",
                         "Three is my limit. Four is showing off."],
            "globe": ["Big place, that.",
                      "I've seen most of it. From a tree.",
                      "Spins nicely, doesn't it."],
            "poof": ["Don't ask.",
                     "That happens sometimes.",
                     "I've never fully understood that either."],
            "paper": ["It's a form. There's always a form.",
                      "I've read this twice. Still nothing.",
                      "Paperwork. In a jungle. Honestly."],
        ],

        jokes: [
            Joke(setup: "Why don't gorillas ever get lost?",
                 punchline: "We go where the food is. It's not complicated."),
            Joke(setup: "What do you call a gorilla with a banana in each ear?",
                 punchline: "Anything you like. He can't hear you."),
            Joke(setup: "Why did the banana go to the doctor?",
                 punchline: "It wasn't peeling well."),
            Joke(setup: "What's a gorilla's favourite kind of key?",
                 punchline: "A mon-key. I'm not sorry."),
            Joke(setup: "How do you catch a runaway gorilla?",
                 punchline: "Wait. We stop."),
            Joke(setup: "Why don't gorillas play cards in the jungle?",
                 punchline: "Too many cheetahs."),
            Joke(setup: "What do you get if you cross a gorilla with a calculator?",
                 punchline: "A very large problem solver."),
            Joke(setup: "I went on a banana diet.",
                 punchline: "I didn't lose weight, but you should see me climb."),
            Joke(setup: "What's the hardest thing about being this size?",
                 punchline: "Doorways. It's always doorways."),
            Joke(setup: "Why did I sit down?",
                 punchline: "That's not a joke. I just wanted to explain myself."),
            Joke(setup: "They say you shouldn't work with animals.",
                 punchline: "And yet here we both are."),
            Joke(setup: "What's grey, has a trunk, and weighs a tonne?",
                 punchline: "Not me. I'm purple and I resent the comparison."),
            Joke(setup: "How many gorillas does it take to change a lightbulb?",
                 punchline: "One. But the ceiling never survives."),
            Joke(setup: "What did the tree say to the gorilla?",
                 punchline: "Please. Not again."),
            Joke(setup: "I'm reading a book about anti-gravity.",
                 punchline: "It's heavy going. Everything is, at my weight."),
            Joke(setup: "Why was the jungle so quiet?",
                 punchline: "Everyone was waiting for me to finish this joke."),
        ],

        facts: Repertoire.sharedFacts + [
            "Gorillas share about ninety-eight percent of their DNA with you. The other two percent is mostly this.",
            "A silverback can weigh over two hundred kilos and still climb a tree. I don't, but he can.",
            "Gorillas build a fresh nest to sleep in every single night. New bed, every night. Think about that.",
            "We have unique nose prints, the way you have fingerprints.",
            "Gorillas hum while they eat. Not a joke — researchers have recorded it.",
            "A gorilla called Koko learned over a thousand signs and kept a pet kitten.",
            "Gorillas are almost entirely vegetarian. Leaves, stems, and yes, fruit.",
            "We can't swim. It's the one thing I'd change.",
            "Chest-beating isn't aggression so much as an announcement of size. It's honest advertising.",
            "Bananas grow pointing upwards, not hanging down. Nobody believes me about this.",
        ],

        twisters: [
            "How much wood would a woodchuck chuck if a woodchuck could chuck wood.",
            "The sixth sick sheikh's sixth sheep's sick.",
            "Big black bug bit a big black bear.",
            "Rubber baby buggy bumpers.",
        ],

        songs: Repertoire.bonziSongs
    )
}
