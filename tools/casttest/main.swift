import AppKit

// The two of them: distinct personalities, complete animation sets, and
// dialogue that only references characters who exist.
_ = NSApplication.shared
var failures = 0
func check(_ label: String, _ ok: Bool, _ detail: String = "") {
    if ok { print("  ok   \(label)") } else { print("  FAIL \(label) \(detail)"); failures += 1 }
}

let bundle = Bundle(path: ProcessInfo.processInfo.environment["BUDDY_APP"] ?? "build/Desktop Buddies.app")!
print("\(Product.current.name): \(Personality.all.count) characters\n")
print("all of them load:")
var stores: [String: SpriteStore] = [:]
for p in Personality.all {
    guard let store = SpriteStore(character: p.id, bundle: bundle) else {
        check("\(p.name) loads", false); continue
    }
    stores[p.id] = store
    check("\(p.name) loads (\(store.animations.count) clips, canvas "
          + "\(Int(store.canvas.width))x\(Int(store.canvas.height)))", true)
}

print("\nevery clip a personality names actually exists:")
for p in Personality.all {
    guard let store = stores[p.id] else { continue }
    var missing: [String] = []
    for name in p.flourishes where store.animation(name) == nil { missing.append(name) }
    for bit in p.bits {
        for name in [bit.intro, bit.loop, bit.outro].compactMap({ $0 })
        where store.animation(name) == nil { missing.append(name) }
    }
    // Everyone needs these. Blinking, greeting and cheering are particular to
    // the Agent characters, which have eye patches and a wave; a Genesis sprite
    // rip has neither.
    var required = ["rest", "arrive", "depart", p.travel.cruise]
    if p.speaks { required += ["blink", "greet", "cheer"] }
    for name in required where store.animation(name) == nil { missing.append(name) }
    if case .flies(let takeoff, _, let land) = p.travel {
        for name in [takeoff, land] where store.animation(name) == nil { missing.append(name) }
    }
    check("\(p.name): no dangling clip names", missing.isEmpty, missing.joined(separator: ", "))

    // Bits that name a talk pose must have one, or the mouth patches would be
    // dropped silently and he'd talk with a still face.
    let badPose = p.bits.compactMap(\.pose).filter { store.talkPoses[$0] == nil }
    check("\(p.name): every named talk pose exists", badPose.isEmpty,
          badPose.joined(separator: ", "))
    if p.speaks {
        check("\(p.name): has a neutral talk pose", store.talkPoses["neutral"] != nil)
    }
}

if Personality.all.contains(where: { $0.id == "peedy" }) {
print("\nthey are actually different:")
let peedy = Personality.peedy, bonzi = Personality.bonzi
let pEn = peedy.pack(.english)!, bEn = bonzi.pack(.english)!
check("different voices in English", pEn.preferredVoice != bEn.preferredVoice,
      "\(pEn.preferredVoice ?? "-") vs \(bEn.preferredVoice ?? "-")")
check("different pitch", pEn.pitch != bEn.pitch)
check("Bonzi speaks more slowly", bEn.rate < pEn.rate, "\(bEn.rate) vs \(pEn.rate)")
// Only one Arabic voice ships with macOS, so in Arabic they have to be told
// apart by pitch and pace instead.
let pAr = peedy.pack(.arabic)!, bAr = bonzi.pack(.arabic)!
check("Arabic: told apart by pitch",
      pAr.pitch.rawValue > bAr.pitch.rawValue + 0.4,
      "\(pAr.pitch.rawValue) vs \(bAr.pitch.rawValue)")
check("Arabic: told apart by pace", bAr.rate < pAr.rate, "\(bAr.rate) vs \(pAr.rate)")
check("Arabic: they sing in different registers",
      abs(pAr.singingRoot - bAr.singingRoot) > 40,
      "\(pAr.singingRoot) vs \(bAr.singingRoot)")
check("Bonzi does less, less often",
      bonzi.beatRange.lowerBound > peedy.beatRange.lowerBound)
check("no shared small talk", Set(pEn.idle).isDisjoint(with: Set(bEn.idle)))
check("no shared jokes",
      Set(pEn.jokes.map(\.setup)).isDisjoint(with: Set(bEn.jokes.map(\.setup))))
check("no shared songs",
      Set(pEn.songs.map(\.title)).isDisjoint(with: Set(bEn.songs.map(\.title)))
      && Set(pAr.songs.map(\.title)).isDisjoint(with: Set(bAr.songs.map(\.title))))
check("they do share general knowledge",
      !Set(pEn.facts).isDisjoint(with: Set(bEn.facts)))
check("each has themed facts of its own",
      !Set(pEn.facts).subtracting(bEn.facts).isEmpty
          && !Set(bEn.facts).subtracting(pEn.facts).isEmpty
          && !Set(pAr.facts).subtracting(bAr.facts).isEmpty)
check("Peedy flies, Bonzi doesn't", {
    if case .flies = peedy.travel, case .hops = bonzi.travel { return true }
    return false
}())

print("\nboth languages:")
for p in Personality.all where p.speaks {
    for lang in Language.allCases {
        guard let pack = p.packs[lang] else {
            check("\(p.id) has a \(lang.rawValue) pack", false); continue
        }
        check("\(p.id)/\(lang.rawValue): named in its own language", !pack.name.isEmpty)
        let pools = [pack.greetings, pack.idle, pack.poked, pack.pokedAgain,
                     pack.dropped, pack.leaving, pack.welcomeBack, pack.noticed]
        check("\(p.id)/\(lang.rawValue): every pool has lines",
              pools.allSatisfy { !$0.isEmpty })
        check("\(p.id)/\(lang.rawValue): four times of day",
              pack.timeOfDay.count == 4, "\(pack.timeOfDay.count)")
        check("\(p.id)/\(lang.rawValue): jokes, facts, riddles, songs",
              !pack.jokes.isEmpty && !pack.facts.isEmpty
                  && !pack.riddles.isEmpty && !pack.songs.isEmpty)
        // Every bit names a line pool, or it performs in silence.
        let missing = p.bits.map(\.talk).filter { pack.byBit[$0] == nil }
        check("\(p.id)/\(lang.rawValue): every bit has something to say",
              missing.isEmpty, missing.joined(separator: ", "))
        // A pack whose voice isn't installed must not be offered.
        check("\(p.id)/\(lang.rawValue): resolves a voice or declares none",
              pack.preferredVoice == nil || Voice.installed(pack.preferredVoice!))
    }
}

// Arabic really is Arabic, not English sitting in the wrong slot.
func isArabic(_ s: String) -> Bool {
    s.unicodeScalars.contains { (0x0600...0x06FF).contains(Int($0.value)) }
}
for p in Personality.all where p.speaks {
    guard let ar = p.packs[.arabic] else { continue }
    let all = ar.greetings + ar.idle + ar.poked + ar.dropped + ar.leaving
        + ar.jokes.map(\.setup) + ar.jokes.map(\.punchline) + ar.facts
        + ar.riddles.map(\.question) + ar.twisters
    check("\(p.id): the Arabic pack is written in Arabic",
          all.allSatisfy(isArabic), all.first { !isArabic($0) } ?? "")
    let en = p.packs[.english]!
    check("\(p.id): the two languages share no lines",
          Set(ar.idle).isDisjoint(with: Set(en.idle)))
}

print("\nvoices match the language they're speaking:")
// The bug this guards: a voice chosen in one language being reapplied in
// another. An English synthesiser handed Arabic doesn't fail — it spells it
// out, at roughly ten times the length and completely unintelligible.
for p in Personality.all where p.speaks {
    for lang in Language.allCases {
        guard let id = p.pack(lang)?.preferredVoice else { continue }
        check("\(p.id)/\(lang.rawValue): picks a \(lang.rawValue) voice",
              Voice.canSpeak(id, lang),
              "\(Voice.languageCode(of: id) ?? "?") voice for \(lang.rawValue)")
    }
}
check("an English voice is rejected for Arabic",
      !Voice.canSpeak("com.apple.speech.synthesis.voice.Fred", .arabic))
check("an Arabic voice is rejected for English",
      !Voice.canSpeak("com.apple.voice.super-compact.ar-001.Maged", .english))
check("a voice that isn't installed is rejected",
      !Voice.canSpeak("com.example.nope", .english))
// The menu must only ever offer voices that can speak the current language.
for lang in Language.allCases {
    let offered = Voice.options(for: lang)
    check("the \(lang.rawValue) voice menu only offers \(lang.rawValue) voices",
          offered.allSatisfy { Voice.canSpeak($0.identifier, lang) },
          offered.first { !Voice.canSpeak($0.identifier, lang) }?.title ?? "")
    check("the \(lang.rawValue) voice menu isn't empty", !offered.isEmpty)
}

}

print("\nbanter:")
let cast = Set(Personality.all.map(\.id))
let usable = Banter.available(for: cast, in: .english)
check("there are exchanges for a full cast", usable.count > 10, "\(usable.count)")
check("every exchange has at least two speakers",
      usable.allSatisfy { Set($0.map(\.who)).count > 1 })
check("no exchange names an unknown character",
      Language.allCases.allSatisfy { l in
          Banter.all(in: l).allSatisfy { Set($0.map(\.who)).isSubset(of: cast) }
      })
check("there are Arabic exchanges too",
      Banter.available(for: cast, in: .arabic).count > 10,
      "\(Banter.available(for: cast, in: .arabic).count)")
check("solo casts get no exchanges",
      Banter.available(for: ["peedy"], in: .english).isEmpty
          && Banter.available(for: [], in: .arabic).isEmpty)
// A move in dialogue must exist for whoever performs it, or the line loses its
// gesture with no warning.
var badMoves: [String] = []
for exchange in Language.allCases.flatMap({ Banter.all(in: $0) }) {
    for line in exchange {
        guard let move = line.move, let store = stores[line.who] else { continue }
        if store.animation(move) == nil { badMoves.append("\(line.who):\(move)") }
    }
}
check("every gesture in dialogue exists for its speaker", badMoves.isEmpty,
      badMoves.joined(separator: ", "))
check("lines alternate rather than one of them monologuing",
      Language.allCases.flatMap({ Banter.all(in: $0) }).allSatisfy { exchange in
          !zip(exchange, exchange.dropFirst()).contains { $0.who == $1.who }
      })

print(failures == 0 ? "\nall checks passed" : "\n\(failures) FAILED")
exit(failures == 0 ? 0 : 1)
