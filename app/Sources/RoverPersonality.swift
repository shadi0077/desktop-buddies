import Foundation

extension Personality {
    /// The search dog: eager, literal, and entirely without guile.
    ///
    /// Rover's whole personality is that he is helping. He is not always
    /// helping with the thing you wanted. Where Peedy is vain and Bonzi is
    /// unbothered, Rover is *pleased* — about the desk, the day, and you being
    /// at it.
    ///
    /// His sprite set has no mouth patches, so he pants while he talks. It
    /// reads better than a still pose and it is what the original did.
    static let rover = Personality(
        id: "rover",
        scale: 1.35,
        beatRange: 8...19,
        roaming: .init(distance: 220...760, speed: 340, arc: 0, restlessness: 1.6),
        travel: .hops(cruise: "walk"),

        flourishes: ["turn", "greet", "fetch", "sit", "sniff", "pant"],

        bits: [
            .init(intro: "readStart", loop: "reading", outro: "readEnd",
                  hold: 10...22, talk: "reading", pose: nil),
            .init(intro: "paperFetch", loop: "paper", outro: "paperDrop",
                  hold: 8...18, talk: "paper", pose: nil),
            .init(intro: "sniff", loop: "sniff", outro: nil,
                  hold: 6...14, talk: "sniffing", pose: nil),
        ],

        packs: [.english: roverEnglish, .arabic: roverArabic],
        talkLoop: "pant"
    )

    static let roverEnglish = SpeechPack(
        name: "Rover",
        voiceOrder: ["com.apple.speech.synthesis.voice.rocko.premium",
                     "com.apple.speech.synthesis.voice.Junior",
                     "com.apple.speech.synthesis.voice.Fred"],
        preferredLocales: ["en-US", "en-GB"],
        pitch: .high,
        rate: 0.58,
        singingRoot: 175,          // F3

        greetings: [
            "You're here! Great. Great great great.",
            "Hello! I found you. That's my job.",
            "Oh good, it's you. I checked. It's definitely you.",
            "Hi! I've been sitting. Very well, I might add.",
            "You're back! Was it long? It felt long.",
            "Right! What are we looking for?",
        ],

        idle: [
            "I could find something. Say the word.",
            "Sitting. Still sitting. Very good at this.",
            "That folder smells organised.",
            "Nothing lost? I can wait. I'm good at waiting. Not that good.",
            "I checked under the taskbar. Nothing there.",
            "If you lose something, I'm right here. Ready. Extremely ready.",
            "Ooh. Was that a click? That was a click.",
            "This is a nice desk. Firm. Good corners.",
            "I've smelled every file in this folder. They're fine.",
            "I'm not sleeping. My eyes are just resting downward.",
            "Somebody should reward the dog. Only a suggestion.",
            "I like it when the windows are all lined up.",
            "You've been very still. Should I be worried?",
            "I would fetch you a coffee, but I'd carry it in my mouth.",
            "I looked in the recycle bin. There were things in it. That's all I know.",
            "Sometimes I just wag. No reason. It's free.",
            "Good desk. Good chair. Good person.",
            "I've been thinking about lunch, and it's not even mine.",
            "Nothing missing yet. But the day's young.",
            "Every file you have, I have sniffed. You're welcome.",
        ],

        poked: [
            "Yes! Yes? Yes.",
            "Oh! Hello!",
            "Was that a pat? That felt like a pat.",
            "I'm awake! I was always awake.",
            "Right here! Reporting!",
            "Aww, do that again.",
        ],

        pokedAgain: [
            "Still here! Still delighted!",
            "You are very good at this.",
            "I could do this all day, and I would.",
            "Okay, that's four. Not that I'm counting. Five.",
            "I'm going to fall over from happiness in a minute.",
        ],

        dropped: [
            "Ooh, new spot! Smells different.",
            "Down here now! Good. Fine. Excellent.",
            "I like it here. I liked it there too.",
            "Thank you for the ride.",
        ],

        leaving: [
            "Off to check something! Back in a bit.",
            "I'll just do a lap.",
            "Going to go look at a thing. It'll be quick.",
            "Back soon! Don't lose anything while I'm out.",
        ],

        welcomeBack: [
            "You're back you're back you're back!",
            "I sat by the door. Metaphorically.",
            "Nothing went missing. I watched it all.",
            "Oh good. I was starting to sniff things.",
        ],

        noticed: [
            "Ooh, a pointer!",
            "I see it. I see it moving.",
            "Something's happening!",
            "That's a good cursor. That's a very good cursor.",
        ],

        timeOfDay: ["Morning! Best part of the day. All of it's the best part.",
                    "Afternoon. Still going. Still keen.",
                    "Evening. Everything's slower and I like it.",
                    "It's late. You should sleep. I'll keep watch. I'll sleep too."],

        byBit: [
            "reading": ["I'm reading. I mostly look at the pictures.",
                        "This page smells like the last page.",
                        "It's a good book. I've had a good sniff of it.",
                        "I don't know what this word is, but I respect it."],
            "paper": ["Got the paper! Nobody asked, but I got it.",
                      "Front page is a bit grim. Sports is fine.",
                      "I fetched this. Please notice that I fetched it.",
                      "Bit chewed at the corner. That was structural."],
            "sniffing": ["It went this way. I'm nearly sure.",
                         "Something's here. Something's always here.",
                         "Ooh. That's a smell with a story.",
                         "Searching! This is my whole thing!"],
        ],

        jokes: [
            Joke(setup: "What do you call a dog that can do search?",
                 punchline: "Employed."),
            Joke(setup: "Why did the dog sit by the computer?",
                 punchline: "He heard it had a mouse."),
            Joke(setup: "What's a dog's favourite kind of file?",
                 punchline: "A bone. I know. I'm sorry."),
            Joke(setup: "I asked my dog to find the missing document.",
                 punchline: "He found a sandwich. Different result, still a win."),
            Joke(setup: "Why don't dogs use the recycle bin?",
                 punchline: "We've been in the bin. It's not for recycling."),
            Joke(setup: "What did the dog say to the folder?",
                 punchline: "Open up, I know you're hiding something."),
            Joke(setup: "How does a dog stop a video?",
                 punchline: "He presses paws."),
        ],

        facts: [
            "A dog's sense of smell is somewhere between ten thousand and a hundred thousand times better than yours. No offence.",
            "Dogs have about three hundred million scent receptors. You have six million.",
            "A wagging tail isn't always happy. To the right is happy. To the left is uneasy.",
            "Dogs can smell time, in a way — a scent fading tells them how long ago it was left.",
            "Puppies are born deaf. The ears open at about three weeks.",
            "A dog's nose print is unique, like a fingerprint.",
            "Dogs sniff with one nostril first — the right — when a smell is new.",
        ],

        riddles: [
            Riddle(question: "I have a tail and a nose but no pockets. What am I?",
                   answer: "Me! It's me."),
            Riddle(question: "What gets wetter the more it dries?",
                   answer: "A towel. I've tested this thoroughly."),
            Riddle(question: "What has to be broken before you can use it?",
                   answer: "An egg. Don't let me near it."),
        ],

        twisters: [
            "Rover rummages round rough rugs.",
            "A big black dog dug a big black bone.",
        ],

        songs: Repertoire.roverSongs
    )
}
