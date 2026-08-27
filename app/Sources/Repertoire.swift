import Foundation

// Everything he performs, as opposed to the small talk in Chatter.
// All of it ships in the bundle: he has no network access and never will.

struct Joke {
    let setup: String
    let punchline: String
}

struct Riddle {
    let question: String
    let answer: String
}

/// One sung note: a syllable, its pitch in semitones above the tonic, and how
/// many beats it occupies.
struct Note {
    let text: String
    let step: Int
    let beats: Double

    init(_ text: String, _ step: Int, _ beats: Double = 1) {
        self.text = text
        self.step = step
        self.beats = beats
    }
}

/// A line of lyric and the notes that carry it. The lyric is what the bubble
/// shows; the notes are what actually gets sung.
struct SongPhrase {
    let lyric: String
    let notes: [Note]
}

struct Song {
    let title: String
    /// Something he says before starting.
    let intro: String
    let secondsPerBeat: Double
    let phrases: [SongPhrase]
    /// Sung tonic in Hz, when this song wants one of its own.
    let root: Double?

    init(title: String, intro: String, secondsPerBeat: Double,
         phrases: [SongPhrase], root: Double? = nil) {
        self.title = title
        self.intro = intro
        self.secondsPerBeat = secondsPerBeat
        self.phrases = phrases
        self.root = root
    }
}

enum Repertoire {

    /// Facts either of them can tell — neither has a claim on octopuses.
    /// Each personality appends its own themed ones to this.
    static let sharedFacts: [String] = [
        "Honey doesn't spoil. Archaeologists have found pots of it thousands of years old, still edible.",
        "Octopuses have three hearts and blue blood.",
        "Bananas are berries. Strawberries are not. Botany is a shambles.",
        "Wombats produce cube-shaped droppings, and nobody has entirely explained why.",
        "There are more possible games of chess than there are atoms in the observable universe.",
        "A day on Venus lasts longer than a year on Venus.",
        "Venus also spins backwards compared with nearly every other planet.",
        "Sharks are older than trees by about a hundred million years.",
        "Cleopatra lived closer in time to the Moon landing than to the building of the Great Pyramid.",
        "The Eiffel Tower is taller in summer. The iron expands in the heat.",
        "Sea otters hold hands while they sleep so they don't drift apart.",
        "Scotland's national animal is the unicorn.",
        "The shortest war on record was over in about forty minutes.",
        "Your stomach lining replaces itself every few days. Otherwise it would digest itself.",
        "Sound travels roughly four times faster in water than in air.",
        "There are more trees on Earth than there are stars in the Milky Way.",
        "The first computer to sing was an IBM 704, in 1961. It sang Daisy Bell.",
        "In 1947 Grace Hopper's team taped a moth into a logbook as the first actual case of a bug being found.",
        "Bit is short for binary digit. The statistician John Tukey coined it.",
        "Ray Tomlinson chose the at sign for email in 1971 because nobody else was using that key.",
        "A googol is a one followed by a hundred zeros. It was named by a nine-year-old.",
        "The first Macintosh shipped in 1984 with a hundred and twenty-eight kilobytes of memory.",
    ]

    /// Riddles work in either voice, so they're shared.
    static let riddles: [Riddle] = [
        Riddle(question: "What has keys but opens no locks?", answer: "A piano."),
        Riddle(question: "What gets wetter the more it dries?", answer: "A towel."),
        Riddle(question: "I speak without a mouth and hear without ears. What am I?",
               answer: "An echo."),
        Riddle(question: "What has hands but cannot clap?", answer: "A clock."),
        Riddle(question: "The more you take, the more you leave behind. What am I?",
               answer: "Footsteps."),
        Riddle(question: "What has a head and a tail, but no body?", answer: "A coin."),
        Riddle(question: "What travels the world while staying in one corner?",
               answer: "A stamp."),
        Riddle(question: "What goes up but never comes down?", answer: "Your age."),
        Riddle(question: "What has many teeth but cannot bite?", answer: "A comb."),
        Riddle(question: "What has one eye but cannot see?", answer: "A needle."),
        Riddle(question: "What can you catch but never throw?", answer: "A cold."),
        Riddle(question: "What has a neck but no head?", answer: "A bottle."),
    ]

    // MARK: - Songs

    /// All well out of copyright. The melodies are approximate — these are
    /// speech synthesisers, not a choir.
    static let peedySongs: [Song] = [
        Song(title: "Daisy Bell",
             intro: "This was the first song a computer ever sang. Nineteen sixty-one.",
             secondsPerBeat: 0.42,
             phrases: [
                SongPhrase(lyric: "Daisy, Daisy,", notes: [
                    Note("Dai", 7, 1.5), Note("sy", 4), Note("Dai", 0, 1.5), Note("sy", 2),
                ]),
                SongPhrase(lyric: "give me your answer do.", notes: [
                    Note("give", 4), Note("me", 5), Note("your", 7),
                    Note("ans", 4, 1.5), Note("wer", 2), Note("do", 0, 2),
                ]),
                SongPhrase(lyric: "I'm half crazy,", notes: [
                    Note("I'm", 7), Note("half", 9), Note("cra", 11, 1.5), Note("zy", 9),
                ]),
                SongPhrase(lyric: "all for the love of you.", notes: [
                    Note("all", 7), Note("for", 5), Note("the", 4),
                    Note("love", 2), Note("of", 4), Note("you", 0, 2),
                ]),
             ]),

        Song(title: "Twinkle, Twinkle",
             intro: "Everybody knows this one. Join in if you like.",
             secondsPerBeat: 0.40,
             phrases: [
                SongPhrase(lyric: "Twinkle, twinkle, little star,", notes: [
                    Note("Twin", 0), Note("kle", 0), Note("twin", 7), Note("kle", 7),
                    Note("lit", 9), Note("tle", 9), Note("star", 7, 2),
                ]),
                SongPhrase(lyric: "how I wonder what you are.", notes: [
                    Note("how", 5), Note("I", 5), Note("won", 4), Note("der", 4),
                    Note("what", 2), Note("you", 2), Note("are", 0, 2),
                ]),
             ]),

        Song(title: "Row Your Boat",
             intro: "A short one. I have a small lung capacity.",
             secondsPerBeat: 0.38,
             phrases: [
                SongPhrase(lyric: "Row, row, row your boat,", notes: [
                    Note("Row", 0, 1.5), Note("row", 0, 1.5), Note("row", 0),
                    Note("your", 2), Note("boat", 4, 2),
                ]),
                SongPhrase(lyric: "gently down the stream.", notes: [
                    Note("gent", 4), Note("ly", 2), Note("down", 4),
                    Note("the", 5), Note("stream", 7, 2),
                ]),
             ]),

        Song(title: "Polly Wolly Doodle",
             intro: "This one has a Polly in it, so I consider it mine.",
             secondsPerBeat: 0.36,
             phrases: [
                SongPhrase(lyric: "Fare thee well, fare thee well,", notes: [
                    Note("Fare", 7), Note("thee", 7), Note("well", 4, 1.5),
                    Note("fare", 7), Note("thee", 7), Note("well", 4, 1.5),
                ]),
                SongPhrase(lyric: "fare thee well my fairy fay.", notes: [
                    Note("fare", 7), Note("thee", 9), Note("well", 7), Note("my", 4),
                    Note("fair", 2), Note("y", 0), Note("fay", 0, 2),
                ]),
             ]),
    ]

    /// Slower and lower, to suit him. Swing Low is on the list for the obvious
    /// reason: he arrives on a vine.
    static let bonziSongs: [Song] = [
        Song(title: "Swing Low, Sweet Chariot",
             intro: "This one's about swinging. I feel qualified.",
             secondsPerBeat: 0.52,
             phrases: [
                SongPhrase(lyric: "Swing low, sweet chariot,", notes: [
                    Note("Swing", 7, 1.5), Note("low", 4, 1.5), Note("sweet", 0),
                    Note("cha", 4), Note("ri", 7), Note("ot", 7, 2),
                ]),
                SongPhrase(lyric: "coming for to carry me home.", notes: [
                    Note("com", 9), Note("ing", 7), Note("for", 4), Note("to", 4),
                    Note("car", 2), Note("ry", 4), Note("me", 2), Note("home", 0, 2),
                ]),
             ]),

        Song(title: "Coming Round the Mountain",
             intro: "Long song. I'll do the good bit.",
             secondsPerBeat: 0.44,
             phrases: [
                SongPhrase(lyric: "She'll be coming round the mountain", notes: [
                    Note("She'll", 0), Note("be", 0), Note("com", 0), Note("ing", 4),
                    Note("round", 7), Note("the", 7), Note("moun", 4), Note("tain", 4),
                ]),
                SongPhrase(lyric: "when she comes.", notes: [
                    Note("when", 2), Note("she", 4), Note("comes", 0, 2),
                ]),
             ]),

        Song(title: "Michael Row the Boat Ashore",
             intro: "Steady one. Everything I do is steady.",
             secondsPerBeat: 0.50,
             phrases: [
                SongPhrase(lyric: "Michael, row the boat ashore,", notes: [
                    Note("Mi", 0), Note("chael", 4), Note("row", 7), Note("the", 7),
                    Note("boat", 9), Note("a", 7), Note("shore", 4, 2),
                ]),
                SongPhrase(lyric: "hallelujah.", notes: [
                    Note("hal", 4), Note("le", 2), Note("lu", 0), Note("jah", 0, 2),
                ]),
             ]),
    ]
}
