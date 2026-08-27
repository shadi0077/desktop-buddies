import Foundation

/// A line in a two-hander, and who says it.
struct BanterLine {
    let who: String
    let text: String
    let move: String?

    init(_ who: String, _ text: String, _ move: String? = nil) {
        self.who = who
        self.text = text
        self.move = move
    }
}

/// Exchanges between the two of them.
///
/// The comedy is entirely in the contrast: Peedy talks too much and moves
/// constantly, Bonzi says one thing slowly and then stops. Neither wins.
enum Banter {
    static let exchanges: [[BanterLine]] = [
        [BanterLine("peedy", "You're very still.", "point"),
         BanterLine("bonzi", "Thank you."),
         BanterLine("peedy", "It wasn't a compliment."),
         BanterLine("bonzi", "I'm taking it as one.", "shrug")],

        [BanterLine("bonzi", "Do you ever stop moving?", "handsOnHips"),
         BanterLine("peedy", "No."),
         BanterLine("bonzi", "Right.")],

        [BanterLine("peedy", "What are you thinking about?"),
         BanterLine("bonzi", "Bananas."),
         BanterLine("peedy", "You said that last time.", "shrug"),
         BanterLine("bonzi", "It's still true.")],

        [BanterLine("bonzi", "You could perch on me, you know.", "point"),
         BanterLine("peedy", "I could. I won't. But I could.")],

        [BanterLine("peedy", "I've been up since dawn.", "cheer"),
         BanterLine("bonzi", "I know. I heard.", "scratchHead")],

        [BanterLine("bonzi", "Nice wings."),
         BanterLine("peedy", "Nice... arms."),
         BanterLine("bonzi", "Thanks.")],

        [BanterLine("peedy", "Race you to the other side.", "flourish"),
         BanterLine("bonzi", "No."),
         BanterLine("peedy", "Fair enough.")],

        [BanterLine("bonzi", "Is it always this loud in your head?"),
         BanterLine("peedy", "Yes! Why, is that unusual?", "cheer")],

        [BanterLine("peedy", "Squawk!", "greet"),
         BanterLine("bonzi", "Ook.", "greet"),
         BanterLine("peedy", "We should do this more often.")],

        [BanterLine("bonzi", "I read a book once."),
         BanterLine("peedy", "About what?"),
         BanterLine("bonzi", "I've forgotten. It was heavy, though.", "shrug")],

        [BanterLine("peedy", "Do you think they're watching us?", "lookAround"),
         BanterLine("bonzi", "Constantly."),
         BanterLine("peedy", "Good. Look busy.", "flourish")],

        [BanterLine("bonzi", "You're quite small."),
         BanterLine("peedy", "I am efficiently sized.", "announce")],

        [BanterLine("peedy", "I could fly to the moon."),
         BanterLine("bonzi", "You could not."),
         BanterLine("peedy", "I could fly towards it.")],

        [BanterLine("bonzi", "Want a banana?"),
         BanterLine("peedy", "I want a cracker."),
         BanterLine("bonzi", "I don't have one of those.", "shrug")],

        [BanterLine("peedy", "What's the plan?"),
         BanterLine("bonzi", "There isn't one."),
         BanterLine("peedy", "Perfect.", "cheer")],

        [BanterLine("bonzi", "Careful up there."),
         BanterLine("peedy", "I'm always careful."),
         BanterLine("bonzi", "You are never careful.", "handsOnHips")],

        [BanterLine("peedy", "I've had an idea.", "gestureUp"),
         BanterLine("bonzi", "Go on."),
         BanterLine("peedy", "...It's gone.", "shrug")],

        [BanterLine("bonzi", "Purple's a good colour."),
         BanterLine("peedy", "Green's better."),
         BanterLine("bonzi", "That's fine.")],

        [BanterLine("peedy", "Do you sing?"),
         BanterLine("bonzi", "Slowly."),
         BanterLine("peedy", "That's not a no.", "point")],

        [BanterLine("bonzi", "This desktop's getting crowded.", "lookAround"),
         BanterLine("peedy", "It was crowded when you arrived.")],

        [BanterLine("peedy", "Say something clever.", "point"),
         BanterLine("bonzi", "No."),
         BanterLine("peedy", "That'll do.")],

        [BanterLine("bonzi", "How do you stay so shiny?"),
         BanterLine("peedy", "Relentless preening. It's a full-time job.", "flourish")],

        [BanterLine("peedy", "Between us we've got wings and arms."),
         BanterLine("bonzi", "And no plan."),
         BanterLine("peedy", "And no plan.", "shrug")],
    ]

    /// Exchanges that only involve characters currently on screen.
    static func available(for cast: Set<String>) -> [[BanterLine]] {
        exchanges.filter { exchange in
            Set(exchange.map(\.who)).isSubset(of: cast) && Set(exchange.map(\.who)).count > 1
        }
    }
}
