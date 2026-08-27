import AppKit

// The two of them: distinct personalities, complete animation sets, and
// dialogue that only references characters who exist.
_ = NSApplication.shared
var failures = 0
func check(_ label: String, _ ok: Bool, _ detail: String = "") {
    if ok { print("  ok   \(label)") } else { print("  FAIL \(label) \(detail)"); failures += 1 }
}

let bundle = Bundle(path: "build/Peedy.app")!
print("both characters load:")
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
    for name in ["rest", "blink", "arrive", "depart", "greet", "cheer",
                 p.travel.cruise] where store.animation(name) == nil {
        missing.append(name)
    }
    if case .flies(let takeoff, _, let land) = p.travel {
        for name in [takeoff, land] where store.animation(name) == nil { missing.append(name) }
    }
    check("\(p.name): no dangling clip names", missing.isEmpty, missing.joined(separator: ", "))

    // Bits that name a talk pose must have one, or the mouth patches would be
    // dropped silently and he'd talk with a still face.
    let badPose = p.bits.compactMap(\.pose).filter { store.talkPoses[$0] == nil }
    check("\(p.name): every named talk pose exists", badPose.isEmpty,
          badPose.joined(separator: ", "))
    check("\(p.name): has a neutral talk pose", store.talkPoses["neutral"] != nil)
}

print("\nthey are actually different:")
let peedy = Personality.peedy, bonzi = Personality.bonzi
check("different voices", peedy.preferredVoice != bonzi.preferredVoice,
      "\(peedy.preferredVoice) vs \(bonzi.preferredVoice)")
check("different pitch", peedy.pitch != bonzi.pitch)
check("Bonzi speaks more slowly", bonzi.rate < peedy.rate, "\(bonzi.rate) vs \(peedy.rate)")
check("Bonzi does less, less often",
      bonzi.beatRange.lowerBound > peedy.beatRange.lowerBound)
check("no shared small talk",
      Set(peedy.idle).isDisjoint(with: Set(bonzi.idle)))
check("no shared jokes",
      Set(peedy.jokes.map(\.setup)).isDisjoint(with: Set(bonzi.jokes.map(\.setup))))
check("no shared songs",
      Set(peedy.songs.map(\.title)).isDisjoint(with: Set(bonzi.songs.map(\.title))))
check("they do share general knowledge",
      !Set(peedy.facts).isDisjoint(with: Set(bonzi.facts)))
check("each has themed facts of its own",
      !Set(peedy.facts).subtracting(bonzi.facts).isEmpty
          && !Set(bonzi.facts).subtracting(peedy.facts).isEmpty)
check("Peedy flies, Bonzi doesn't", {
    if case .flies = peedy.travel, case .hops = bonzi.travel { return true }
    return false
}())

print("\nbanter:")
let cast: Set<String> = ["peedy", "bonzi"]
let usable = Banter.available(for: cast)
check("there are exchanges for a full cast", usable.count > 10, "\(usable.count)")
check("every exchange has at least two speakers",
      usable.allSatisfy { Set($0.map(\.who)).count > 1 })
check("no exchange names an unknown character",
      Banter.exchanges.allSatisfy { Set($0.map(\.who)).isSubset(of: cast) })
check("solo casts get no exchanges",
      Banter.available(for: ["peedy"]).isEmpty && Banter.available(for: []).isEmpty)
// A move in dialogue must exist for whoever performs it, or the line loses its
// gesture with no warning.
var badMoves: [String] = []
for exchange in Banter.exchanges {
    for line in exchange {
        guard let move = line.move, let store = stores[line.who] else { continue }
        if store.animation(move) == nil { badMoves.append("\(line.who):\(move)") }
    }
}
check("every gesture in dialogue exists for its speaker", badMoves.isEmpty,
      badMoves.joined(separator: ", "))
check("lines alternate rather than one of them monologuing",
      Banter.exchanges.allSatisfy { exchange in
          !zip(exchange, exchange.dropFirst()).contains { $0.who == $1.who }
      })

print(failures == 0 ? "\nall checks passed" : "\n\(failures) FAILED")
exit(failures == 0 ? 0 : 1)
