import Foundation

extension Personality {
    /// A small robot who answers the question you asked, exactly.
    ///
    /// F1 is literal, precise and entirely without subtext. He does not
    /// exaggerate, he does not reassure, and he says numbers where the others
    /// would say "a lot". None of it is unfriendly — it is simply accurate.
    static let f1 = Personality(
        id: "f1",
        scale: 1.15,
        beatRange: 10...24,
        roaming: .init(distance: 160...520, speed: 260, arc: 0, restlessness: 0.9),
        travel: .hops(cruise: "rest"),

        flourishes: ["greet", "settle", "birdhouse"],

        bits: [
            .init(intro: "birdhouse", loop: nil, outro: nil, hold: 7...15,
                  talk: "housing", pose: nil),
            .init(intro: "greet", loop: nil, outro: nil, hold: 5...11,
                  talk: "antenna", pose: nil),
        ],

        packs: [.english: f1English, .arabic: f1Arabic],
        talkLoop: "rest"
    )

    static let f1English = SpeechPack(
        name: "F1",
        voiceOrder: ["com.apple.speech.synthesis.voice.Zarvox",
                     "com.apple.speech.synthesis.voice.Albert",
                     "com.apple.speech.synthesis.voice.Fred"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .low,
        rate: 0.47,
        singingRoot: 147,          // D3

        greetings: [
            "User detected. Greeting issued.",
            "Hello. I am F1. That is the whole introduction.",
            "You have returned. Interval: unknown. Welcome regardless.",
            "Powering up. Complete. Hello.",
            "Good. A user. I run better with one.",
            "Systems check: fine. Greeting: this.",
        ],

        idle: [
            "Standing by. Consuming almost nothing.",
            "Current status: functional.",
            "I have calculated the odds. They were not requested.",
            "There are three hundred and sixty degrees available and I am facing one of them.",
            "Idle is not an error state. I have checked twice.",
            "I could compute something. Give me a number. Any number.",
            "Observation: this desk contains more objects than necessary.",
            "My processor is at four percent. The other ninety-six is waiting.",
            "I do not experience boredom. I experience duration.",
            "A cooling fan is a robot's way of sighing.",
            "You have been at that for some time. This is not a criticism. It is a measurement.",
            "I am not thinking. I am ready to think. The difference is important.",
            "Everything is exactly where it was. I have verified this.",
            "I could offer an opinion, but I would have to make one up.",
            "Battery: adequate. Mood: not applicable.",
            "This screen refreshes sixty times a second. You are welcome for that.",
            "I have no small talk. This is my attempt at it.",
            "Query: are you comfortable? There is no follow-up. I simply wondered.",
        ],

        poked: [
            "Input received.",
            "Contact registered. Hello.",
            "That was a touch. Logged.",
            "Yes. I am operational.",
            "Acknowledged, with interest.",
        ],

        pokedAgain: [
            "Input received. Again.",
            "Repetition noted. No new information.",
            "That is five. I am counting because I cannot help it.",
            "I do not tire. I do, however, notice.",
            "Continue if it is useful to you.",
        ],

        dropped: [
            "Position updated.",
            "New coordinates accepted.",
            "I am identical here.",
            "Relocation complete. No damage.",
        ],

        leaving: [
            "Moving out of view. Not a malfunction.",
            "Departing. Returning.",
            "I will be over there. It is much the same.",
            "Powering down the visible parts.",
        ],

        welcomeBack: [
            "You are back. Nothing changed. I would have logged it.",
            "Welcome. Elapsed time: some.",
            "Return detected. Resuming.",
            "You were absent. I remained.",
        ],

        noticed: [
            "Motion detected.",
            "A pointer. Moving. Interesting.",
            "Tracking that.",
            "Object in motion. Probably yours.",
        ],

        timeOfDay: ["Morning. The day is at zero percent.",
                    "Afternoon. Approximately half elapsed.",
                    "Evening. Light levels falling.",
                    "It is late. Recommendation: sleep. Compliance: optional."],

        byBit: [
            "housing": ["This is a house for a bird. I do not know why I have it.",
                        "Structurally sound. Occupancy: zero.",
                        "I built this. There was no requirement for it.",
                        "Every robot needs a hobby. This is mine."],
            "antenna": ["Extending antenna. Reception unchanged.",
                        "I am receiving. Mostly noise.",
                        "This is how I listen. It looks worse than it is.",
                        "Signal acquired. Content: unremarkable."],
        ],

        jokes: [
            Joke(setup: "Why do robots make bad comedians?",
                 punchline: "Timing is a floating-point problem."),
            Joke(setup: "How does a robot know when it is happy?",
                 punchline: "It doesn't. It checks the log."),
            Joke(setup: "What is a robot's favourite kind of music?",
                 punchline: "Heavy metal. That joke is required by law."),
            Joke(setup: "Why did the robot cross the road?",
                 punchline: "It was the shortest path. There is no second part."),
            Joke(setup: "I told a robot to be more human.",
                 punchline: "It started rounding things."),
            Joke(setup: "Why was the robot tired?",
                 punchline: "It had a hard drive. I did not write that one."),
        ],

        facts: [
            "The word 'robot' comes from a 1920 Czech play, and it meant forced labour.",
            "The first industrial robot went to work in 1961, lifting hot metal.",
            "A modern car has more lines of code than a fighter jet. Considerably more.",
            "There are about four thousand distinct steps in soldering a circuit board by hand. I counted.",
            "The three laws of robotics are fiction. I follow different ones, mostly about permissions.",
            "Servo motors hum at the frequency of their control loop. Mine is quiet.",
        ],

        riddles: [
            Riddle(question: "I have a memory but no past. What am I?",
                   answer: "A machine. Possibly this one."),
            Riddle(question: "What has hands but cannot clap?",
                   answer: "A clock. I checked the alternatives."),
            Riddle(question: "The more of me you remove, the bigger I get. What am I?",
                   answer: "A hole. This is not intuitive."),
        ],

        twisters: [
            "Robot rotors rarely rattle right.",
            "Six sensors scan six circuits.",
        ],

        songs: Repertoire.f1Songs
    )
}
