import Foundation

extension Personality {
    /// Rides a surfboard across your desktop and is not worried about anything.
    ///
    /// Earl's whole outlook is that it will probably be fine. He is the only
    /// one of them who never offers to help, never announces anything and
    /// never checks. He is here, the water's warm, and you should relax.
    static let earl = Personality(
        id: "earl",
        scale: 1.3,
        beatRange: 12...28,
        roaming: .init(distance: 300...900, speed: 380, arc: 22, restlessness: 1.4),
        travel: .hops(cruise: "rest"),

        flourishes: ["greet", "flourish", "ball", "card"],

        bits: [
            .init(intro: "sunglasses", loop: nil, outro: "sunglassesOff",
                  hold: 9...20, talk: "shades", pose: nil),
            .init(intro: "pyjamas", loop: nil, outro: "pyjamasOff",
                  hold: 8...16, talk: "sleepy", pose: nil),
            .init(intro: "ball", loop: nil, outro: nil, hold: 6...12,
                  talk: "ball", pose: nil),
        ],

        packs: [.english: earlEnglish, .arabic: earlArabic],
        talkLoop: "rest"
    )

    static let earlEnglish = SpeechPack(
        name: "Earl",
        voiceOrder: ["com.apple.speech.synthesis.voice.reed.premium",
                     "com.apple.speech.synthesis.voice.Ralph",
                     "com.apple.speech.synthesis.voice.Fred"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .low,
        rate: 0.46,
        singingRoot: 165,          // E3

        greetings: [
            "Hey. Nice of you to show up.",
            "Oh, hey. Water's fine.",
            "There you are. No rush.",
            "Hey man. Or whoever. Hey.",
            "Cool, you're here. Do your thing.",
            "Morning. Or whatever it is.",
        ],

        idle: [
            "It's all good.",
            "Whatever happens, happens after lunch.",
            "You ever just... not? It's underrated.",
            "The desktop's calm today. I like calm.",
            "No waves, no worries.",
            "I'm not doing nothing. I'm doing this.",
            "That deadline's not going anywhere. It'll wait.",
            "You're working too hard. That's just an observation.",
            "Sun's out somewhere.",
            "I don't have a plan. I have a direction. Sort of.",
            "Take the long way round. Same arrival, better trip.",
            "If it's not fun, do it slower.",
            "Nothing's on fire. I'd have mentioned it.",
            "Good sitting. Real quality sitting you're doing.",
            "I've been on this board since the nineties. Still fine.",
            "One thing at a time, and mostly none of them.",
            "That window can stay open. It's not hurting anyone.",
            "Chill's a skill, man. You practise it.",
        ],

        poked: [
            "Whoa. Easy.",
            "Hey! Yeah?",
            "Cool, cool. What's up?",
            "You rang, or whatever.",
            "Mm? Oh, hey.",
        ],

        pokedAgain: [
            "Alright, alright.",
            "You're really into this.",
            "Still me, man.",
            "Cool. Great. Same as before.",
            "This is a lot of energy for a Tuesday.",
        ],

        dropped: [
            "Nice landing.",
            "Cool spot. Good vibe over here.",
            "Yeah, this works.",
            "Wherever, man. It's all desktop.",
        ],

        leaving: [
            "Catch you later.",
            "I'm gonna drift off that way for a bit.",
            "Later, man.",
            "Gonna go check the surf. There isn't any. Still going.",
        ],

        welcomeBack: [
            "Oh hey, you're back. I didn't move.",
            "There you are. Nothing happened. It was great.",
            "Welcome back, man.",
            "You were gone? Huh.",
        ],

        noticed: [
            "Whoa, movement.",
            "Hey, I see you.",
            "Something's happening over there. Mildly interesting.",
            "Cool cursor.",
        ],

        timeOfDay: ["Morning, man. Take it slow.",
                    "Afternoon. Best time to do less.",
                    "Evening. Now we're talking.",
                    "It's late, man. Nothing good gets decided now."],

        byBit: [
            "shades": ["Shades on. Everything's better dimmer.",
                       "Can't see a thing. Worth it.",
                       "Sun's not out, but you plan ahead.",
                       "These are prescription. They're not."],
            "sleepy": ["Don't mind me. Recharging.",
                       "Naps aren't lazy, they're maintenance.",
                       "I do my best thinking horizontal.",
                       "Five more minutes. Or forty."],
            "ball": ["Watch this. Actually, don't. Might not work.",
                     "Just messing about.",
                     "Hand-eye coordination, man. Or antenna-eye.",
                     "I could do this all day. I plan to."],
        ],

        jokes: [
            Joke(setup: "Why don't surfers ever hurry?",
                 punchline: "The wave's already decided."),
            Joke(setup: "What did the surfer say to the deadline?",
                 punchline: "Nothing. He didn't see it coming."),
            Joke(setup: "Why did the bug bring a board to work?",
                 punchline: "Same reason anyone does. Escape route."),
            Joke(setup: "What's the difference between me and a to-do list?",
                 punchline: "I'm still here in the morning."),
            Joke(setup: "I tried working nine to five.",
                 punchline: "The nine part was the problem. And the five."),
            Joke(setup: "How many surfers does it take to change a bulb?",
                 punchline: "None. It's kind of nice in the dark."),
        ],

        facts: [
            "Surfing was documented in Hawaii in 1778, and it was already ancient by then.",
            "A wave doesn't move water forward, it moves energy through it. The water stays roughly put.",
            "The longest recorded ride is over three hours, on a tidal bore in Brazil.",
            "Insects like me have six legs and no bones. Structurally, it's all skin.",
            "Antennae smell things. Mine are mostly decorative.",
            "The word 'chill' meant cold for six hundred years before it meant relax.",
        ],

        riddles: [
            Riddle(question: "I come in sets, break, and never apologise. What am I?",
                   answer: "A wave, man."),
            Riddle(question: "What goes up and never comes down?",
                   answer: "Your age. Bit heavy, sorry."),
            Riddle(question: "The more you have of me, the less you see. What am I?",
                   answer: "Darkness. Or these sunglasses."),
        ],

        twisters: [
            "Six slick surfers slid sideways.",
            "Earl's early wave rolled over rolling rocks.",
        ],

        songs: Repertoire.earlSongs
    )
}
