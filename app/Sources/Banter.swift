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
        [BanterLine("peedy", "أنت ساكن مرة.", "point"),
         BanterLine("bonzi", "مشكور."),
         BanterLine("peedy", "ما كان مدح."),
         BanterLine("bonzi", "بآخذها مدح.", "shrug")],

        [BanterLine("bonzi", "أنت ما تهدأ أبد؟", "handsOnHips"),
         BanterLine("peedy", "لا."),
         BanterLine("bonzi", "زين، فهمت.")],

        [BanterLine("peedy", "وش تفكر فيه؟"),
         BanterLine("bonzi", "في الموز."),
         BanterLine("peedy", "قلت كذا آخر مرة.", "shrug"),
         BanterLine("bonzi", "ولا زال صحيح.")],

        [BanterLine("bonzi", "تقدر تقعد على كتفي، تدري؟", "point"),
         BanterLine("peedy", "أقدر. بس ما بسوي. لكن أقدر.")],

        [BanterLine("peedy", "أنا صاحي من الفجر.", "cheer"),
         BanterLine("bonzi", "أدري. سمعتك.", "scratchHead")],

        [BanterLine("bonzi", "أجنحتك حلوة."),
         BanterLine("peedy", "و... ذراعينك حلوة."),
         BanterLine("bonzi", "مشكور.")],

        [BanterLine("peedy", "نتسابق للطرف الثاني؟", "flourish"),
         BanterLine("bonzi", "لا."),
         BanterLine("peedy", "معك حق.")],

        [BanterLine("bonzi", "راسك دايم بهالصخب؟"),
         BanterLine("peedy", "إي! ليه، هذا شي غريب؟", "cheer")],

        [BanterLine("peedy", "تتوقع يراقبوننا؟", "lookAround"),
         BanterLine("bonzi", "على طول."),
         BanterLine("peedy", "زين. تظاهر إنك مشغول.", "flourish")],

        [BanterLine("bonzi", "أنت صغير."),
         BanterLine("peedy", "أنا على قد شغلي بالضبط.", "announce")],

        [BanterLine("peedy", "وش الخطة؟"),
         BanterLine("bonzi", "ما فيه خطة."),
         BanterLine("peedy", "ممتاز.", "cheer")],

        [BanterLine("bonzi", "دير بالك فوق."),
         BanterLine("peedy", "أنا حريص دايم."),
         BanterLine("bonzi", "أنت ما حرصت مرة.", "handsOnHips")],

        [BanterLine("peedy", "جتني فكرة.", "gestureUp"),
         BanterLine("bonzi", "قل."),
         BanterLine("peedy", "...راحت.", "shrug")],

        [BanterLine("bonzi", "البنفسجي لون حلو."),
         BanterLine("peedy", "الأخضر أحلى."),
         BanterLine("bonzi", "ولا يهمك.")],

        [BanterLine("peedy", "تغنّي؟"),
         BanterLine("bonzi", "على مهلي."),
         BanterLine("peedy", "يعني ما قلت لا.", "point")],

        [BanterLine("bonzi", "الشاشة بدت تزحم.", "lookAround"),
         BanterLine("peedy", "كانت زحمة من يوم جيت.")],

        [BanterLine("peedy", "قل شي ذكي.", "point"),
         BanterLine("bonzi", "لا."),
         BanterLine("peedy", "يكفي.")],

        [BanterLine("bonzi", "تبي موزة؟"),
         BanterLine("peedy", "أبغى بسكوتة."),
         BanterLine("bonzi", "ما عندي.", "shrug")],

        [BanterLine("bonzi", "كيف تضل لامع كذا؟"),
         BanterLine("peedy", "تنظيف ريش على طول. دوام كامل.", "flourish")],

        [BanterLine("peedy", "بيني وبينك أجنحة وذراعين."),
         BanterLine("bonzi", "وبلا خطة."),
         BanterLine("peedy", "وبلا خطة.", "shrug")],

        [BanterLine("peedy", "تعال نتقهوى.", "point"),
         BanterLine("bonzi", "أنا ما أشرب قهوة."),
         BanterLine("peedy", "إذًا تعال بس اقعد.")],

        [BanterLine("bonzi", "الجو حار اليوم."),
         BanterLine("peedy", "أنا عندي ريش، أنت وش عذرك؟"),
         BanterLine("bonzi", "أنا عندي فرو. نفس المشكلة.", "shrug")],
    ]

    // MARK: - Exchanges for any pair

    /// Nine characters make thirty-six pairings, and hand-writing a set for
    /// each would be neither possible nor good — most of them would be filler
    /// written to fill a grid.
    ///
    /// So the hand-written exchanges above stay exactly as they are, for the
    /// two they were written for, and every other pair draws on these: lines
    /// that work in any mouth, because they are about the only thing all of
    /// them have in common — being two strangers stuck on somebody else's
    /// desktop. `A` and `B` are substituted for whoever is actually present.
    /// No gestures, since a clip one of them has is not a clip the other does.
    static let anyPair: [[BanterLine]] = [
        [BanterLine("A", "Do you ever wonder what's behind the wallpaper?"),
         BanterLine("B", "No."),
         BanterLine("A", "Fair enough.")],

        [BanterLine("A", "How long have you been here?"),
         BanterLine("B", "Since they installed me. You?"),
         BanterLine("A", "Same. We should have met sooner.")],

        [BanterLine("B", "They're not going to click on us, you know."),
         BanterLine("A", "I know. I'm staying anyway.")],

        [BanterLine("A", "Is it just me, or is this desktop getting fuller?"),
         BanterLine("B", "It's not just you.")],

        [BanterLine("B", "What do you do when nobody's looking?"),
         BanterLine("A", "The same thing. That's rather the point of me.")],

        [BanterLine("A", "We could move to the other screen."),
         BanterLine("B", "There's another screen?"),
         BanterLine("A", "Sometimes. It comes and goes.")],

        [BanterLine("B", "You're standing in front of something important."),
         BanterLine("A", "How important?"),
         BanterLine("B", "Hard to say now.")],

        [BanterLine("A", "Do you think they've saved recently?"),
         BanterLine("B", "Don't. You'll worry them.")],

        [BanterLine("B", "I like it when they leave the screen on all night."),
         BanterLine("A", "You would.")],

        [BanterLine("A", "Nobody has ever asked me what I want."),
         BanterLine("B", "What do you want?"),
         BanterLine("A", "I hadn't got that far.")],

        [BanterLine("B", "Careful, that's the edge."),
         BanterLine("A", "It's fine. I've fallen off before."),
         BanterLine("B", "And?"),
         BanterLine("A", "You come back at the other side.")],

        [BanterLine("A", "Quiet today."),
         BanterLine("B", "It was quiet yesterday too."),
         BanterLine("A", "I know. I'm making conversation.")],

        [BanterLine("B", "Were we supposed to be useful?"),
         BanterLine("A", "Originally."),
         BanterLine("B", "Right.")],

        [BanterLine("A", "Do you get tired?"),
         BanterLine("B", "I get slower. It might be the same thing.")],
    ]

    static let anyPairArabic: [[BanterLine]] = [
        [BanterLine("A", "تتوقع وش وراء الخلفية؟"),
         BanterLine("B", "لا."),
         BanterLine("A", "طيب، عادي.")],

        [BanterLine("A", "من متى وأنت هنا؟"),
         BanterLine("B", "من يوم نصّبوني. وأنت؟"),
         BanterLine("A", "نفس الشي. چان تعارفنا من زمان.")],

        [BanterLine("B", "ما راح يضغطون علينا، تدري."),
         BanterLine("A", "أدري. وباقي على أي حال.")],

        [BanterLine("A", "الشاشة تزدحم، ولا أنا اللي أتوهم؟"),
         BanterLine("B", "لا، مو أنت.")],

        [BanterLine("B", "وش تسوي لما ما أحد يطالع؟"),
         BanterLine("A", "نفس الشي. هذي وظيفتي أصلاً.")],

        [BanterLine("A", "نقدر ننتقل للشاشة الثانية."),
         BanterLine("B", "في شاشة ثانية؟"),
         BanterLine("A", "أحياناً. تجي وتروح.")],

        [BanterLine("B", "أنت واقف قدام شي مهم."),
         BanterLine("A", "مهم قد إيش؟"),
         BanterLine("B", "صعب أحكم الحين.")],

        [BanterLine("A", "تتوقع إنه حفظ الملف؟"),
         BanterLine("B", "لا تقول كذا... بتقلقه.")],

        [BanterLine("B", "أحب لما يخلّون الشاشة شغالة الليل كله."),
         BanterLine("A", "طبعاً تحب.")],

        [BanterLine("A", "ما أحد سألني وش أبغى."),
         BanterLine("B", "طيب وش تبغى؟"),
         BanterLine("A", "ما وصلت لهالمرحلة.")],

        [BanterLine("B", "انتبه، هذي الحافة."),
         BanterLine("A", "عادي، طحت قبل."),
         BanterLine("B", "وبعدين؟"),
         BanterLine("A", "ترجع من الطرف الثاني.")],

        [BanterLine("A", "اليوم هادي."),
         BanterLine("B", "وأمس كان هادي."),
         BanterLine("A", "أدري. بس أفتح سيرة.")],

        [BanterLine("B", "كنا المفروض نفيد بشي؟"),
         BanterLine("A", "في الأصل."),
         BanterLine("B", "آها.")],
    ]

    /// The hand-written exchanges, which name real characters.
    static func all(in language: Language) -> [[BanterLine]] {
        language == .arabic ? arabicExchanges : exchanges
    }

    /// Exchanges two characters on screen could actually have.
    ///
    /// A pair with something written for them uses it; everyone else gets the
    /// any-pair set with their own names put in, so a cast of nine never runs
    /// into two characters who have nothing to say to each other.
    static func available(for cast: Set<String>, in language: Language) -> [[BanterLine]] {
        let written = all(in: language).filter { exchange in
            let speakers = Set(exchange.map(\.who))
            return speakers.isSubset(of: cast) && speakers.count > 1
        }
        guard cast.count > 1 else { return written }

        let generic = language == .arabic ? anyPairArabic : anyPair
        let ids = cast.sorted()
        var out = written
        for (i, a) in ids.enumerated() {
            for b in ids[(i + 1)...] {
                // Skip a pair that already has its own material.
                let hasOwn = written.contains { Set($0.map(\.who)) == [a, b] }
                if hasOwn { continue }
                for exchange in generic {
                    out.append(exchange.map {
                        BanterLine($0.who == "A" ? a : b, $0.text, $0.move)
                    })
                }
            }
        }
        return out
    }
}
