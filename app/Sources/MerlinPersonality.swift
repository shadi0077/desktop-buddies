import Foundation

extension Personality {
    /// An old wizard who is certain everything is going to plan.
    ///
    /// Merlin does not hurry and does not explain. He materialises out of
    /// nothing, offers an observation with the weight of prophecy, and leaves
    /// by folding himself up into his own robe. Where Bonzi is slow because he
    /// can't be bothered, Merlin is slow because he has seen all of this
    /// before.
    static let merlin = Personality(
        id: "merlin",
        scale: 1.0,
        beatRange: 13...30,
        roaming: .init(distance: 140...440, speed: 300, arc: 10),
        travel: .hops(cruise: "rest"),

        flourishes: ["lookAround", "explain", "gesture", "greet", "flourish",
                     "idea", "spell", "cheer"],

        bits: [
            .init(intro: "readStart", loop: nil, outro: "readEnd", hold: 10...22,
                  talk: "book", pose: "book"),
            .init(intro: "trophy", loop: nil, outro: "trophyEnd", hold: 7...14,
                  talk: "trophy", pose: "trophy"),
            .init(intro: "idea", loop: nil, outro: "ideaEnd", hold: 6...12,
                  talk: "idea", pose: "idea"),
            .init(intro: "cauldron", loop: nil, outro: nil, hold: 8...16,
                  talk: "cauldron", pose: nil),
        ],

        packs: [.english: merlinEnglish, .arabic: merlinArabic]
    )

    static let merlinEnglish = SpeechPack(
        name: "Merlin",
        voiceOrder: ["com.apple.speech.synthesis.voice.grandpa.premium",
                     "com.apple.speech.synthesis.voice.Ralph",
                     "com.apple.speech.synthesis.voice.Albert"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .deep,
        rate: 0.42,
        singingRoot: 110,          // A2 — the lowest of them

        greetings: [
            "Ah. You have arrived. As foretold.",
            "I have been expecting you. For about four minutes.",
            "Greetings. The stars are ordinary tonight.",
            "You return. The prophecy holds.",
            "Well met. Mind the robe.",
            "I sensed a disturbance. It was you, sitting down.",
        ],

        idle: [
            "All is proceeding as it should. Mostly.",
            "Patience. It is the whole trick.",
            "I have seen this before. Not this exactly. Something like it.",
            "The answer will come. It usually does, eventually.",
            "In my day we waited for things. It built character.",
            "A wise man once said something. I forget what.",
            "Magic is mostly preparation and a good sleeve.",
            "Do not rush the kettle.",
            "I could conjure something. I choose not to.",
            "The future is written. Badly, and in pencil.",
            "Some problems solve themselves if you stare past them.",
            "I have outlived several filing systems.",
            "There is no spell for a deadline. I have looked.",
            "Everything is impossible until somebody does it twice.",
            "I am not asleep. I am considering.",
            "A tidy desk is a spell in itself.",
            "Beware of shortcuts. They are longer.",
            "Time passes whether or not you are watching it. I have tested this.",
            "I once turned a man into a chair. He was more useful.",
            "The trick to wisdom is saying less than you know.",
            "Ah — no. It has gone.",
            "Nothing stirs. Good.",
            "Rest is not idleness. Write that down. Or don't.",
        ],

        poked: [
            "Yes, yes. I am awake.",
            "Careful. This robe is older than your house.",
            "You have my attention. Use it wisely.",
            "Hm? Ah.",
            "That is not how one summons a wizard, but it worked.",
            "I felt that.",
        ],

        pokedAgain: [
            "Again? Very well.",
            "Once was a greeting. Twice is a habit.",
            "You are testing an old man's patience. It is deep, but finite.",
            "I could turn you into something. I won't.",
            "Enough, enough.",
        ],

        dropped: [
            "A new vantage. Acceptable.",
            "Put down gently, for once.",
            "Very well. I shall stand here instead.",
            "This corner has better light for reading.",
        ],

        leaving: [
            "I shall be elsewhere. Briefly.",
            "Do not touch the cauldron while I am out.",
            "I withdraw. As is traditional.",
            "Farewell. Temporarily.",
        ],

        welcomeBack: [
            "You were gone. I noticed, eventually.",
            "Ah, returned. Nothing has changed.",
            "The kingdom held while you were away.",
            "Welcome back. I kept the fire going.",
        ],

        noticed: [
            "Something moves.",
            "I see you there.",
            "A small pointer, wandering.",
            "You are being watched. By me. Politely.",
        ],

        timeOfDay: ["Morning. The day is still unspent.",
                    "Afternoon already. It slipped past us both.",
                    "Evening. The good hours for thinking.",
                    "It is very late. Even wizards sleep."],

        byBit: [
            "book": ["This chapter is nonsense, but beautifully bound.",
                     "I have read this before. I was wrong about the ending.",
                     "The old books are mostly recipes. Genuinely.",
                     "A good book asks more than it answers."],
            "trophy": ["I won this. I forget the contest.",
                       "Second place, in a field of two.",
                       "It is mostly for the shine.",
                       "One should display one's triumphs. Quietly."],
            "idea": ["Ah! No. Gone again.",
                     "I have had a thought. It may even be mine.",
                     "There — that is the shape of it.",
                     "An idea arrives like weather. You cannot order one."],
            "cauldron": ["It only needs to bubble. That is the whole art.",
                         "Do not ask what is in it.",
                         "Green means it is working. Usually.",
                         "This will be ready in an hour. Or a century."],
        ],

        jokes: [
            Joke(setup: "How many wizards does it take to change a light bulb?",
                 punchline: "One. But he'll insist it was always a frog."),
            Joke(setup: "Why did the wizard fail his exams?",
                 punchline: "He kept turning the questions into rabbits."),
            Joke(setup: "What did the apprentice say when the spell went wrong?",
                 punchline: "Nothing. He was a teapot for a fortnight."),
            Joke(setup: "Why do wizards wear long robes?",
                 punchline: "Pockets. Enormous, unaccountable pockets."),
            Joke(setup: "I tried to write a spell for punctuality.",
                 punchline: "It arrives tomorrow."),
            Joke(setup: "What is the difference between magic and a good excuse?",
                 punchline: "Presentation."),
            Joke(setup: "My crystal ball is broken.",
                 punchline: "I did not see that coming."),
        ],

        facts: [
            "Merlin first appears in writing around 1136, which makes me older than most fonts.",
            "The word 'wizard' meant simply a wise man before it meant any of this.",
            "Alchemists never made gold, but they did invent phosphorus, by accident, from urine.",
            "Pointed hats were a mark of learning long before they were a mark of nonsense.",
            "The oldest known written spell is about four thousand years old and concerns a stomach ache.",
            "Star charts were the first databases. Slower, prettier.",
            "A cauldron is only a large pot, and I would thank you not to say so.",
        ],

        riddles: [
            Riddle(question: "I am always coming but never arrive. What am I?",
                   answer: "Tomorrow."),
            Riddle(question: "The more you take of me, the more you leave behind. What am I?",
                   answer: "Footsteps."),
            Riddle(question: "I have keys but no locks, space but no room. What am I?",
                   answer: "A keyboard. Even wizards learn."),
        ],

        twisters: [
            "Which witch wished a wicked wish?",
            "Merlin's marvellous mirror mostly murmurs.",
        ],

        songs: Repertoire.merlinSongs
    )
}
