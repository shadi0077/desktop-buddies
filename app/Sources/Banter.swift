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

    /// The Arabic double act. Written rather than translated — the rhythm of
    /// an exchange is the joke, and that has to be built in the language it's
    /// spoken in.
    static let arabicExchanges: [[BanterLine]] = [
        [BanterLine("peedy", "أنت ساكن جدًا.", "point"),
         BanterLine("bonzi", "شكرًا."),
         BanterLine("peedy", "لم يكن مديحًا."),
         BanterLine("bonzi", "سآخذها كمديح.", "shrug")],

        [BanterLine("bonzi", "هل تتوقف عن الحركة أبدًا؟", "handsOnHips"),
         BanterLine("peedy", "لا."),
         BanterLine("bonzi", "فهمت.")],

        [BanterLine("peedy", "بماذا تفكر؟"),
         BanterLine("bonzi", "بالموز."),
         BanterLine("peedy", "قلت هذا آخر مرة.", "shrug"),
         BanterLine("bonzi", "وما زال صحيحًا.")],

        [BanterLine("bonzi", "تستطيع الوقوف على كتفي، تعرف ذلك.", "point"),
         BanterLine("peedy", "أستطيع. لن أفعل. لكنني أستطيع.")],

        [BanterLine("peedy", "أنا مستيقظ منذ الفجر.", "cheer"),
         BanterLine("bonzi", "أعرف. سمعتك.", "scratchHead")],

        [BanterLine("bonzi", "أجنحة جميلة."),
         BanterLine("peedy", "و... أذرع جميلة."),
         BanterLine("bonzi", "شكرًا.")],

        [BanterLine("peedy", "أسابقك إلى الطرف الآخر.", "flourish"),
         BanterLine("bonzi", "لا."),
         BanterLine("peedy", "منطقي.")],

        [BanterLine("bonzi", "هل رأسك صاخب هكذا دائمًا؟"),
         BanterLine("peedy", "نعم! لماذا، هل هذا غريب؟", "cheer")],

        [BanterLine("peedy", "أتظن أنهم يراقبوننا؟", "lookAround"),
         BanterLine("bonzi", "باستمرار."),
         BanterLine("peedy", "جيد. تظاهر بالانشغال.", "flourish")],

        [BanterLine("bonzi", "أنت صغير الحجم."),
         BanterLine("peedy", "أنا بحجم عملي تمامًا.", "announce")],

        [BanterLine("peedy", "ما الخطة؟"),
         BanterLine("bonzi", "لا توجد خطة."),
         BanterLine("peedy", "ممتاز.", "cheer")],

        [BanterLine("bonzi", "احترس هناك في الأعلى."),
         BanterLine("peedy", "أنا حذر دائمًا."),
         BanterLine("bonzi", "أنت لست حذرًا أبدًا.", "handsOnHips")],

        [BanterLine("peedy", "خطرت لي فكرة.", "gestureUp"),
         BanterLine("bonzi", "تفضل."),
         BanterLine("peedy", "...ذهبت.", "shrug")],

        [BanterLine("bonzi", "اللون البنفسجي جميل."),
         BanterLine("peedy", "الأخضر أفضل."),
         BanterLine("bonzi", "لا بأس.")],

        [BanterLine("peedy", "هل تغني؟"),
         BanterLine("bonzi", "ببطء."),
         BanterLine("peedy", "هذه ليست إجابة بالنفي.", "point")],

        [BanterLine("bonzi", "سطح المكتب يزدحم.", "lookAround"),
         BanterLine("peedy", "كان مزدحمًا منذ وصلت أنت.")],

        [BanterLine("peedy", "قل شيئًا ذكيًا.", "point"),
         BanterLine("bonzi", "لا."),
         BanterLine("peedy", "يكفي.")],

        [BanterLine("bonzi", "تريد موزة؟"),
         BanterLine("peedy", "أريد بسكويتة."),
         BanterLine("bonzi", "ليست عندي.", "shrug")],

        [BanterLine("bonzi", "كيف تبقى لامعًا هكذا؟"),
         BanterLine("peedy", "تنظيف متواصل للريش. وظيفة بدوام كامل.", "flourish")],

        [BanterLine("peedy", "بيننا أجنحة وأذرع."),
         BanterLine("bonzi", "وبلا خطة."),
         BanterLine("peedy", "وبلا خطة.", "shrug")],
    ]

    static func all(in language: Language) -> [[BanterLine]] {
        language == .arabic ? arabicExchanges : exchanges
    }

    /// Exchanges that only involve characters currently on screen.
    static func available(for cast: Set<String>, in language: Language) -> [[BanterLine]] {
        all(in: language).filter { exchange in
            Set(exchange.map(\.who)).isSubset(of: cast) && Set(exchange.map(\.who)).count > 1
        }
    }
}
