import Foundation

extension Personality {
    /// A blue macaw who thinks he is a broadcast service.
    ///
    /// Max came out of an alert program, and it shows: he treats everything
    /// that happens on the desktop as material for a bulletin nobody asked
    /// for. Brisk, official, entirely sincere. Where Peedy performs and Bonzi
    /// can't be bothered, Max reports.
    static let max = Personality(
        id: "max",
        scale: 0.85,
        beatRange: 11...24,
        roaming: .init(distance: 180...560, speed: 520, arc: 34),
        travel: .hops(cruise: "flap"),

        flourishes: ["lookAround", "cheer", "flourish", "announce", "gesture",
                     "explain", "point", "excited", "wingsOut", "greet"],

        bits: [
            .init(intro: "announce", loop: nil, outro: nil, hold: 7...14,
                  talk: "bulletin", pose: "announce"),
            .init(intro: "excited", loop: nil, outro: nil, hold: 6...12,
                  talk: "breaking", pose: "excited"),
            .init(intro: "point", loop: nil, outro: nil, hold: 6...12,
                  talk: "weather", pose: "point"),
        ],

        packs: [.english: maxEnglish, .arabic: maxArabic]
    )

    static let maxEnglish = SpeechPack(
        name: "Max",
        voiceOrder: ["com.apple.speech.synthesis.voice.Junior",
                     "com.apple.speech.synthesis.voice.Fred"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .low,
        rate: 0.55,
        singingRoot: 220,          // A3 — a clear announcing register

        greetings: [
            "Max here. Standing by.",
            "Good. You're at your desk. Noted.",
            "Reporting for duty.",
            "Max, live from the corner of your screen.",
            "Systems nominal. Bird nominal.",
            "You have one new bird.",
        ],

        idle: [
            "Nothing to report. I'll report that.",
            "All quiet. Suspiciously quiet.",
            "The desktop remains stable.",
            "No incidents in the last four minutes.",
            "Standing by. Standing by is most of the job.",
            "I am monitoring. It's going well.",
            "Update: no update.",
            "This just in: nothing.",
            "I have swept the perimeter. The perimeter is a screen edge.",
            "Everything is where you left it. I checked twice.",
            "Bulletin: your posture has been observed. No further comment.",
            "Situation normal. I'll say it again in a minute in case it changes.",
            "I keep a log. Nobody reads it. I read it.",
            "It's been an uneventful shift. That's the good kind.",
            "There is nothing on the horizon. There is no horizon.",
            "I'd raise an alert, but there's nothing to raise it about.",
            "Quiet day. Quiet week, if we're being honest.",
            "Still here. Still blue.",
            "Consider yourself informed.",
            "That window's been open a while. Not an alert. An observation.",
            "I could file a report about the lack of reports.",
            "Alertness level: alert.",
            "I've checked everything twice, so now I'm checking it a third time.",
            "You would be the first to know. That's the arrangement.",
            "In the absence of news, I present: this.",
        ],

        poked: [
            "Acknowledged.",
            "Alert received!",
            "Yes? Is it something? It's usually not something.",
            "Input registered.",
            "You have my full attention, which was available.",
            "Squawk! Sorry. Unprofessional.",
            "Go ahead.",
            "Receiving you.",
        ],

        pokedAgain: [
            "Also acknowledged.",
            "Repeat received. Same answer.",
            "You are now my top three stories.",
            "I'm going to have to log this.",
            "Message understood the first four times.",
        ],

        dropped: [
            "Relocated. Updating my coordinates.",
            "New position. Same service.",
            "Broadcasting from here now, apparently.",
            "Fine. The signal reaches here too.",
        ],

        leaving: [
            "Off duty. Back shortly.",
            "Taking a short flight. Hold my alerts.",
            "Stepping out of frame.",
            "Handing over to nobody. Back soon.",
        ],

        welcomeBack: [
            "You missed nothing. I was thorough about it.",
            "Welcome back. Nothing happened, at length.",
            "Ah. Resuming service.",
            "You're back. The log is short.",
        ],

        noticed: [
            "Movement detected.",
            "I see a cursor.",
            "Something's happening over there.",
            "Tracking.",
            "Contact.",
        ],

        timeOfDay: ["Morning bulletin: the day is unbroken so far.",
                    "Afternoon shift. Steady as it goes.",
                    "Evening. Winding the broadcast down.",
                    "It is very late. I am filing that."],

        byBit: [
            "bulletin": ["Bulletin: the kettle, somewhere, has boiled.",
                         "In tonight's news: a window was closed. It went well.",
                         "Reports are coming in that you should stretch.",
                         "Headline: local bird has nothing to say, says it anyway."],
            "breaking": ["Breaking! Something moved and it was me.",
                         "This is a developing situation. It is not.",
                         "Stop everything. Actually, don't. False alarm.",
                         "Hold the front page. Then let it go."],
            "weather": ["Outlook: indoors, with a chance of screen.",
                        "Conditions on the desktop: mild, cluttered.",
                        "A cold front is coming through that window. Close it.",
                        "Forecast: more of this."],
        ],

        jokes: [
            Joke(setup: "Why did the news reader get a parrot?",
                 punchline: "For the repeat broadcast."),
            Joke(setup: "What do you call a macaw with no news?",
                 punchline: "Still talking."),
            Joke(setup: "I told my editor my story had no facts in it.",
                 punchline: "He said that's fine, it's an opinion column now."),
            Joke(setup: "Why are alerts always urgent?",
                 punchline: "Because 'this can wait' doesn't get clicked."),
            Joke(setup: "What's blue, feathered, and always on time?",
                 punchline: "Me. And that's the whole joke, I'm afraid."),
            Joke(setup: "How many announcers does it take to change a bulb?",
                 punchline: "One, but he'll mention it four times."),
            Joke(setup: "My producer said to cut it short.",
                 punchline: "So I did. That was it."),
            Joke(setup: "Why did the parrot join the weather desk?",
                 punchline: "He was already repeating himself about the rain."),
        ],

        facts: [
            "Blue and gold macaws can live over sixty years. Long careers.",
            "A macaw's beak can crack a brazil nut, which is more than most tools manage.",
            "Parrots don't have vocal cords. We shape sound with a syrinx.",
            "The first radio news bulletin was broadcast in 1920. I'd have been good at it.",
            "Macaws are left-footed more often than right. Ask me to prove it, I won't.",
            "A flock of macaws is called a company. That's a serious word and I like it.",
            "Wild macaws eat clay to settle their stomachs. Not endorsed.",
            "The word 'bulletin' comes from a little sealed note. Now it's me shouting.",
        ],

        riddles: [
            Riddle(question: "I bring you news you already know, and I'm proud of it. What am I?",
                   answer: "A notification."),
            Riddle(question: "The more of me there is, the less each one means. What am I?",
                   answer: "An alert."),
            Riddle(question: "I repeat what I hear and understand none of it. Bird, or radio?",
                   answer: "Both, if you're unkind about it."),
        ],

        twisters: [
            "Blue macaw broadcasts brief bulletins.",
            "Six sleek breaking stories, briefly spoken.",
        ],

        songs: Repertoire.maxSongs
    )
}
