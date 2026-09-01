"""Author the animation catalogue for each character.

Usage: catalog.py            (writes both)
"""
import json, os


def rng(a, b):
    return list(range(a, b + 1))


# The mouth patches per pose are visemes, not an openness ramp, so they have to
# be ordered before loudness can index them. There is no one measurement that
# works for both characters: Peedy's open beak shows a pink tongue and barely
# changes in darkness, while Bonzi's open mouth is a dark cavity and barely
# changes in warm-pixel span. So measure both and let each character's own data
# decide which one actually discriminates.
from PIL import Image


def _measure(who, index):
    """(vertical span of warm lip/beak pixels, count of dark cavity pixels)."""
    im = Image.open(f"assets/{who}/rgba/{index:04d}.png").convert("RGBA")
    rows, dark = set(), 0
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = im.getpixel((x, y))
            if not a:
                continue
            if r > 150 and g > 80 and b < 130 and r > b + 40:
                rows.add(y)
            if r < 90 and g < 90 and b < 90:
                dark += 1
    return (max(rows) - min(rows) + 1 if rows else 0), dark


def _spread(values):
    lo, hi = min(values), max(values)
    return (hi - lo) / hi if hi > 0 else 0


def measured_ramps(who, talk):
    if not talk:
        # Game rips have no viseme patches — nothing to order.
        print(f"  {who}: no talk poses (sound effects instead of speech)")
        return {}

    """Order every mouth set closed -> widest, using whichever metric separates
    this character's visemes more cleanly."""
    scored = {name: [_measure(who, m) for m in pose["mouths"]]
              for name, pose in talk.items()}

    best, chosen = None, 0
    for metric in (0, 1):
        widest = {max(range(len(v)), key=lambda i: v[i][metric]) for v in scored.values()}
        spread = sum(_spread([x[metric] for x in v]) for v in scored.values()) / len(scored)
        # Fewest disagreements about which viseme is widest wins; ties go to
        # whichever has more dynamic range to work with.
        score = (-len(widest), spread)
        if best is None or score > best:
            best, chosen = score, metric

    print(f"  {who}: using the {'warm-span' if chosen == 0 else 'dark-cavity'} metric "
          f"(agreement {-best[0]}, spread {best[1]:.2f})")
    return {name: [pose["mouths"][i]
                   for i in sorted(range(len(pose["mouths"])),
                                   key=lambda i: scored[name][i][chosen])]
            for name, pose in talk.items()}


# --------------------------------------------------------------------------
# Peedy - quick, fussy, theatrical.
# --------------------------------------------------------------------------
PEEDY = {
    "rest":            (rng(342, 353), 10, True),
    "blink":           ([353, (353, 354), (353, 355), (353, 354), 353], 14, False),
    "lookAround":      (rng(218, 228), 10, False),
    "surprised":       (rng(246, 260), 14, False),
    "greet":           (rng(401, 412), 14, False),
    "announce":        (rng(36, 46), 12, False),
    "shrug":           (rng(280, 286), 12, False),
    "cheer":           (rng(294, 304), 14, False),
    "flourish":        (rng(505, 513), 12, False),
    "gestureUp":       (rng(167, 172), 12, False),
    "gestureDown":     (rng(137, 144), 12, False),
    # 202-210 extends a wing to the viewer's right; mirror it to aim left.
    "point":           (rng(202, 210), 12, False),
    "wingSweep":       (rng(180, 194), 12, False),
    "arrive":          (rng(6, 28), 14, False),
    "depart":          (rng(377, 399), 14, False),
    "takeoff":         (rng(413, 421), 16, False),
    "fly":             (rng(422, 431), 16, True),
    "land":            (rng(432, 441), 16, False),
    "headphonesOn":    (rng(442, 459), 12, False),
    "listening":       (rng(460, 469), 10, True),
    "idea":            (rng(483, 497), 12, False),
    "writeStart":      (rng(521, 530), 12, False),
    "writing":         (rng(531, 543), 12, True),
    "searchStart":     (rng(575, 586), 12, False),
    "telescope":       (rng(587, 616), 14, False),
    "sunglassesOn":    (rng(617, 631), 12, False),
    "sunglassesIdle":  (rng(632, 643), 10, True),
    "proud":           (rng(644, 648), 10, False),
    "readStart":       (rng(656, 673), 12, False),
    "reading":         (rng(681, 697), 10, True),
}

PEEDY_TALK = {
    "neutral":  {"body": 28,  "mouths": rng(29, 35)},
    "reading":  {"body": 673, "mouths": rng(674, 680)},
    "writing":  {"body": 543, "mouths": rng(544, 550)},
    "proud":    {"body": 648, "mouths": rng(649, 655)},
    "announce": {"body": 60,  "mouths": rng(61, 67)},
    "idea":     {"body": 497, "mouths": rng(498, 504)},
}

# --------------------------------------------------------------------------
# Bonzi - slow, heavy, unbothered. A gorilla swings in on a vine and eats a
# banana; nothing about him is quick.
# --------------------------------------------------------------------------
BONZI = {
    "rest":            (rng(999, 1010), 8, True),
    "blink":           ([1010, (1010, 1011), (1010, 1012), (1010, 1011), 1010], 14, False),
    "lookAround":      (rng(74, 87), 10, False),
    "surprised":       (rng(481, 487), 12, False),
    "greet":           (rng(146, 155), 12, False),          # ends on a wave
    "announce":        (rng(1097, 1102), 10, False),
    "shrug":           (rng(28, 45), 11, False),
    "cheer":           (rng(481, 487), 12, False),
    "scratchHead":     (rng(88, 111), 11, False),
    "point":           (rng(125, 145), 11, False),          # arm out, viewer-right
    "handsOnHips":     (rng(112, 117), 10, False),
    # He swings in and out on a vine. Nothing else in either sprite set is
    # anywhere near as good an entrance.
    "arrive":          (rng(1140, 1162), 16, False),
    "depart":          (rng(1163, 1188), 16, False),
    "vineSwing":       (rng(1192, 1213), 14, False),
    "poof":            (rng(163, 180), 13, False),          # inflates, then puffs
    "juggle":          (rng(645, 661), 14, False),          # coconuts
    "eatBanana":       (rng(831, 872), 14, False),
    "sitDown":         (rng(495, 520), 12, False),
    "sitting":         (rng(520, 530), 7, True),
    "standUp":         (rng(531, 541), 12, False),
    "readStart":       (rng(208, 230), 12, False),          # sits and opens a book
    "reading":         (rng(233, 250), 8, True),
    "globe":           (rng(266, 312), 14, False),          # spins a globe
    "headphonesOn":    (rng(794, 802), 12, False),
    "listening":       (rng(803, 824), 9, True),
    "headphonesOff":   (rng(825, 830), 12, False),
    "sunglassesOn":    (rng(445, 455), 12, False),
    "sunglassesIdle":  (rng(455, 465), 8, True),
    "sunglassesOff":   (rng(466, 473), 12, False),
    "paper":           (rng(772, 785), 11, False),
}

BONZI_TALK = {
    "neutral":    {"body": 1102, "mouths": rng(1103, 1109)},
    "announce":   {"body": 487,  "mouths": rng(488, 494)},
    "sunglasses": {"body": 473,  "mouths": rng(474, 480)},
    "paper":      {"body": 764,  "mouths": rng(765, 771)},
    "banana":     {"body": 886,  "mouths": rng(887, 893)},
    "gesture":    {"body": 155,  "mouths": rng(156, 162)},
}

# Costume bits have no "take it off" clips; the intro played backwards undoes
# it, which is how the originals worked too.
REVERSALS = {
    "peedy": [("headphonesOff", "headphonesOn"), ("sunglassesOff", "sunglassesOn"),
              ("readEnd", "readStart"), ("writeEnd", "writeStart"),
              ("searchEnd", "searchStart")],
    "bonzi": [("readEnd", "readStart"), ("globeEnd", "globe")],
}


def norm(steps):
    out = []
    for s in steps:
        out.append({"f": s[0], "o": s[1]} if isinstance(s, tuple) else {"f": s})
    return out


def build(name, clips, talk):
    clips = dict(clips)
    for new, src in REVERSALS.get(name, []):
        steps, fps, _ = clips[src]
        clips[new] = (list(reversed(steps)), fps, False)

    ramps = measured_ramps(name, talk)
    data = {
        "animations": {n: {"steps": norm(s), "fps": f, "loop": l}
                       for n, (s, f, l) in clips.items()},
        "talk": {n: {**pose, "ramp": ramps[n]} for n, pose in talk.items()},
    }
    out = f"app/Resources/characters/{name}"
    os.makedirs(out, exist_ok=True)
    json.dump(data, open(f"{out}/animations.json", "w"), indent=1)
    print(f"{name}: {len(clips)} animations, {len(talk)} talk poses")


import os.path

# --------------------------------------------------------------------------
# Axel - Streets of Rage 2. A beat-'em-up sprite rip: no mouth, no visemes,
# and nothing to say. He punches, and the game's own sound effects do the
# talking.
# --------------------------------------------------------------------------
AXEL = {
    "rest":        (rng(0, 8), 8, True),          # standing guard
    "walk":        (rng(92, 101), 12, True),
    "stretch":     (rng(9, 12), 8, False),
    "jumpKick":    (rng(13, 16), 10, False),
    "punch":       (rng(102, 108), 14, False),
    "jab":         (rng(17, 21), 14, False),
    "kick":        (rng(109, 114), 12, False),
    "highKick":    (rng(22, 27), 12, False),
    "knee":        (rng(144, 149), 12, False),
    "grandUpper":  (rng(51, 55), 12, False),      # the flaming uppercut
    "flameArc":    (rng(76, 81), 12, False),
    "uppercut":    (rng(129, 137), 12, False),
    "celebrate":   (rng(120, 122), 6, False),
    "guard":       (rng(115, 119), 10, False),
    "knockdown":   (rng(88, 90), 8, False),
    "getUp":       (rng(153, 156), 8, False),
    "arrive":      (rng(115, 122), 10, False),
    "depart":      (rng(92, 101), 12, False),
}

# The rest of the Streets of Rage 2 roster. Same sheet format, same bands-are-
# animations structure, so these were read off the frame index the same way.
BLAZE = {
    "rest":       (rng(0, 8), 8, True),
    "walk":       (rng(105, 111), 12, True),
    "punch":      (rng(114, 119), 14, False),
    "kick":       (rng(24, 28), 12, False),
    "highKick":   (rng(128, 131), 12, False),
    "flip":       (rng(34, 40), 14, False),
    "projectile": (rng(50, 57), 12, False),
    "spin":       (rng(59, 63), 12, False),
    "knockdown":  (rng(99, 101), 8, False),
    "arrive":     (rng(34, 40), 14, False),
    "depart":     (rng(105, 111), 12, False),
}

MAX = {
    "rest":       (rng(0, 9), 7, True),
    "walk":       (rng(80, 90), 10, True),
    "punch":      (rng(96, 102), 12, False),
    "flex":       (rng(10, 17), 8, False),
    "grapple":    (rng(39, 47), 12, False),
    "slam":       (rng(48, 55), 12, False),
    "knockdown":  (rng(35, 38), 8, False),
    "arrive":     (rng(10, 17), 8, False),
    "depart":     (rng(80, 90), 10, False),
}

SKATE = {
    "rest":       (rng(0, 11), 9, True),
    "walk":       (rng(96, 103), 13, True),
    "punch":      (rng(104, 110), 14, False),
    "kick":       (rng(16, 18), 12, False),
    "flip":       (rng(35, 43), 14, False),
    "spin":       (rng(57, 66), 14, False),
    "dash":       (rng(67, 73), 14, False),
    "knockdown":  (rng(84, 86), 8, False),
    "arrive":     (rng(44, 47), 10, False),
    "depart":     (rng(96, 103), 13, False),
}

# The Streets of Rage 1 trio, sliced out of one shared sheet, and the enemies.
# The enemy rips are small — a handful of poses each — and several carry a
# palette swatch and a "RIPPED BY ..." caption that read as frames. Those are
# simply not referenced.
# The Streets of Rage 1 rips composite a walk from separate torso and leg
# sprites, so frames 3-10 of each are disembodied legs and there is no whole-body
# walk cycle to use. Those three glide on their idle instead, and roam less to
# make up for it — better than animating a pair of trousers across the desktop.
ADAM = {
    "rest":      (rng(0, 2), 6, True),
    "walk":      (rng(0, 2), 6, True),
    "punch":     (rng(11, 14), 12, False),
    "kick":      (rng(16, 19), 12, False),
    "flip":      (rng(28, 31), 12, False),
    "knockdown": (rng(51, 53), 8, False),
    "arrive":    (rng(11, 14), 10, False),
    "depart":    (rng(0, 2), 6, False),
}

AXEL1 = {
    "rest":      (rng(0, 2), 6, True),
    "walk":      (rng(0, 2), 6, True),
    "punch":     (rng(11, 14), 12, False),
    "kick":      (rng(16, 19), 12, False),
    "flip":      (rng(28, 31), 12, False),
    "knockdown": (rng(50, 51), 8, False),
    "arrive":    (rng(11, 14), 10, False),
    "depart":    (rng(0, 2), 6, False),
}

BLAZE1 = {
    "rest":      (rng(0, 2), 6, True),
    "walk":      (rng(0, 2), 6, True),
    "punch":     (rng(11, 14), 12, False),
    "kick":      (rng(15, 19), 12, False),
    "flip":      (rng(24, 29), 12, False),
    "knockdown": (rng(51, 53), 8, False),
    "arrive":    (rng(11, 14), 10, False),
    "depart":    (rng(0, 2), 6, False),
}

GALSIA = {
    "rest":      (rng(0, 1), 5, True),
    "walk":      (rng(5, 7), 8, True),
    "punch":     (rng(7, 8), 9, False),
    "knockdown": (rng(2, 3), 6, False),
    "arrive":    (rng(5, 8), 8, False),
    "depart":    (rng(5, 7), 8, False),
}

DONOVAN = {
    "rest":      (rng(0, 4), 6, True),
    "walk":      (rng(13, 16), 9, True),
    "punch":     (rng(10, 11), 9, False),
    "flex":      (rng(12, 13), 6, False),
    "knockdown": (rng(6, 8), 6, False),
    "arrive":    (rng(12, 13), 6, False),
    "depart":    (rng(13, 16), 9, False),
}

EAGLE = {
    "rest":      (rng(0, 6), 7, True),
    "walk":      (rng(0, 6), 10, True),      # his sheet has no separate walk
    "kick":      (rng(7, 8), 9, False),
    "highKick":  (rng(15, 16), 8, False),
    "knockdown": (rng(12, 13), 6, False),
    "arrive":    (rng(15, 16), 8, False),
    "depart":    (rng(0, 6), 10, False),
}

SLUM = {
    "rest":      (rng(12, 15), 7, True),
    "walk":      (rng(12, 15), 10, True),
    "punch":     (rng(16, 19), 11, False),
    "attack":    (rng(5, 9), 10, False),
    "knockdown": (rng(10, 11), 6, False),
    "arrive":    (rng(16, 19), 10, False),
    "depart":    (rng(12, 15), 10, False),
}

for name, clips, talk in [("peedy", PEEDY, PEEDY_TALK), ("bonzi", BONZI, BONZI_TALK),
                          ("axel", AXEL, {}), ("blaze", BLAZE, {}),
                          ("max", MAX, {}), ("skate", SKATE, {}),
                          ("adam", ADAM, {}), ("axel1", AXEL1, {}),
                          ("blaze1", BLAZE1, {}), ("galsia", GALSIA, {}),
                          ("donovan", DONOVAN, {}), ("eagle", EAGLE, {}),
                          ("slum", SLUM, {})]:
    # Bonzi is optional; skip anyone whose sprites haven't been imported.
    if not os.path.isdir(f"assets/{name}/rgba") and not os.path.isdir(
            f"app/Resources/characters/{name}/frames"):
        print(f"{name}: no sprites imported, skipping")
        continue
    build(name, clips, talk)
