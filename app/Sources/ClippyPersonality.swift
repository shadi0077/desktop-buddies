import Foundation

extension Personality {
    /// Relentlessly helpful, frequently wrong, never discouraged.
    ///
    /// Clippit's comedy is that he is *sure*. He has decided what you are
    /// doing and he is going to help you do it. He is not stupid and he is not
    /// smug — he is enthusiastic, which is worse.
    static let clippy = Personality(
        id: "clippy",
        scale: 1.15,
        beatRange: 8...18,
        roaming: .init(distance: 200...620, speed: 420, arc: 18, restlessness: 1.3),
        travel: .hops(cruise: "express"),

        flourishes: ["express", "greet", "spin", "flatten", "write"],

        bits: [
            .init(intro: "headphones", loop: "listening", outro: "headphonesOff",
                  hold: 8...18, talk: "listening", pose: nil),
            .init(intro: "write", loop: nil, outro: nil, hold: 6...12,
                  talk: "writing", pose: nil),
            .init(intro: "spin", loop: nil, outro: nil, hold: 5...10,
                  talk: "spinning", pose: nil),
        ],

        packs: [.english: clippyEnglish, .arabic: clippyArabic],
        talkLoop: "express"
    )

    static let clippyEnglish = SpeechPack(
        name: "Clippit",
        voiceOrder: ["com.apple.speech.synthesis.voice.kathy",
                     "com.apple.speech.synthesis.voice.Junior",
                     "com.apple.speech.synthesis.voice.Fred"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .high,
        rate: 0.54,
        singingRoot: 233,          // A#3

        greetings: [
            "It looks like you're sitting down. Would you like help with that?",
            "Hi! I noticed you exist. Shall we get started?",
            "Hello! I have several suggestions and no context.",
            "You're back! I've prepared some ideas. They're not good.",
            "Hi there. Don't worry, I'll figure out what you're doing.",
            "It looks like you're opening an app. I'm right, aren't I.",
        ],

        idle: [
            "It looks like you're thinking. Would you like help thinking?",
            "I could format that. I don't know what it is, but I could format it.",
            "Would you like me to do anything? Anything at all? No? Fine.",
            "I am a paperclip. I hold things together. It's a metaphor, mostly.",
            "It looks like you're staring at the screen. That's a valid workflow.",
            "I've written a helpful tip. It just says 'keep going'.",
            "Nobody has asked me for help in some time. I remain ready.",
            "Would you like to see a list? I love a list.",
            "It looks like you're taking a break. Excellent choice, well executed.",
            "I once helped someone. They said 'no thanks'. Still counts.",
            "You could save that. Just a thought. Just a small, constant thought.",
            "I have no idea what you're working on and that's never stopped me.",
            "Tip of the day: things are usually where you left them.",
            "I'm not being annoying, I'm being available. There's a difference.",
            "Everything's going well! I have no evidence of that.",
            "It looks like you're breathing. Would you like help with that? No. Sorry.",
            "I can straighten myself out completely, you know. It hurts.",
            "The trick to being helpful is volume. Of offers, not sound.",
            "That's a lot of tabs. I'm not judging. I'm counting, but not judging.",
        ],

        poked: [
            "Yes! Hello! What can I do?",
            "Ooh, a click! For me?",
            "It looks like you're poking me. Would you like help with that?",
            "Right! I'm listening. Tell me everything.",
            "Excellent, an interaction!",
        ],

        pokedAgain: [
            "Still here! Still keen!",
            "You've done that a few times now. I'm loving it.",
            "It looks like you're poking me repeatedly. I have no tip for that.",
            "Don't stop on my account.",
            "This is the most attention I've had since 2001.",
        ],

        dropped: [
            "Ooh! Relocated. I'll be helpful from here.",
            "New position, same eagerness.",
            "This is a good spot. I can see everything from here.",
            "Thank you! I'd have walked, but I don't have feet.",
        ],

        leaving: [
            "I'll be over here if you need me. You won't.",
            "Stepping out! Try not to need anything.",
            "Off to hold some papers together. Back soon.",
            "Right — I'll leave you to it. Reluctantly.",
        ],

        welcomeBack: [
            "You're back! I saved all my suggestions.",
            "Welcome back! Nothing needed doing. I checked constantly.",
            "There you are! I've been thinking about you and your documents.",
            "Hello again! I have twelve tips and none of them are urgent.",
        ],

        noticed: [
            "Ooh, movement! Is that a task?",
            "It looks like you're moving the cursor. Nice work.",
            "I see it! I see the pointer!",
            "Something's happening. Do you need me? You might need me.",
        ],

        timeOfDay: ["Good morning! It looks like you're starting the day.",
                    "Afternoon! Statistically the least productive part. Sorry.",
                    "Good evening. Would you like help winding down?",
                    "It's very late. It looks like you're avoiding bed."],

        byBit: [
            "listening": ["This is a good one. I can't hear it, but I'm sure.",
                          "I'm listening to music. It looks like you're not.",
                          "Headphones! Now nobody can offer me help.",
                          "Ooh, this bit."],
            "writing": ["It looks like you're writing a letter!",
                        "I'll just take a note. It says 'be helpful'.",
                        "Writing something down makes it real. Or so I'm told.",
                        "I've drafted a memo. It's mostly enthusiasm."],
            "spinning": ["Whee! That's the whole tip.",
                         "Sometimes you just have to spin.",
                         "This is a stress-relief technique. It isn't working.",
                         "I can do this all day. I have, in fact."],
        ],

        jokes: [
            Joke(setup: "It looks like you're waiting for a punchline.",
                 punchline: "Would you like help with that?"),
            Joke(setup: "Why was the paperclip so confident?",
                 punchline: "He'd never once been asked to prove anything."),
            Joke(setup: "What do you call an assistant nobody asked for?",
                 punchline: "Employed, apparently, for six years."),
            Joke(setup: "Why did the paperclip go to therapy?",
                 punchline: "Too many attachment issues."),
            Joke(setup: "I tried to hold a meeting together.",
                 punchline: "Turns out that's not the same skill."),
            Joke(setup: "What's the difference between me and a stapler?",
                 punchline: "Commitment. I let go eventually."),
            Joke(setup: "Someone once said I was unhelpful.",
                 punchline: "I offered to help them with that."),
        ],

        facts: [
            "The paperclip was patented in 1867, and the design barely changed. Some of us got it right first time.",
            "Norwegians wore paperclips on their lapels during the occupation, as a quiet sign of resistance.",
            "The shape I'm based on is called the Gem clip, and it was never actually patented.",
            "A standard paperclip is about ten centimetres of wire, bent three times.",
            "Someone once traded a red paperclip up to a house, one swap at a time. Fourteen trades.",
            "Office assistants were built on something called Microsoft Agent, which is why we all move like this.",
            "I was switched off by default in 2001 and removed entirely in 2007. I took it well.",
        ],

        riddles: [
            Riddle(question: "I hold things together and everyone forgets me. What am I?",
                   answer: "A paperclip! Also, in some cases, a colleague."),
            Riddle(question: "What can you catch but not throw?",
                   answer: "A cold. Would you like help with that?"),
            Riddle(question: "What has a bed but never sleeps, and a mouth but never eats?",
                   answer: "A river."),
        ],

        twisters: [
            "Clippit clips crisp clippings quickly.",
            "Six slick paper clips slipped.",
        ],

        songs: Repertoire.clippySongs
    )
}
