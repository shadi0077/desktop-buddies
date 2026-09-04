"""Author the animation catalogue for each character.

Usage: catalog.py            (writes both)
"""
import json, os


def rng(a, b):
    return list(range(a, b + 1))


# The mouth patches per pose are visemes, not an openness ramp, so they have to
# be ordered before loudness can index them. No one measurement works for every
# character: Bonzi's open mouth is a dark cavity and barely changes in warm-pixel
# span, Peedy's open beak shows a tongue, and Max's beak is warm all over so its
# span hardly moves at all (31 to 36 pixels across a whole set) while the tongue
# behind it goes from 0 pixels to 17. So measure three ways and let each
# character's own data decide which one actually discriminates.
from PIL import Image


def _measure(who, index):
    """(warm lip/beak span, dark cavity pixels, mouth-interior pixels)."""
    im = Image.open(f"assets/{who}/rgba/{index:04d}.png").convert("RGBA")
    rows, dark, inside = set(), 0, 0
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = im.getpixel((x, y))
            if not a:
                continue
            if r > 150 and g > 80 and b < 130 and r > b + 40:
                rows.add(y)
            if r < 90 and g < 90 and b < 90:
                dark += 1
            # Pink: a tongue, or the inside of a mouth. Only visible when open.
            if r > 130 and g < 140 and b > 60 and r > g + 40 and b > g - 20:
                inside += 1
    return (max(rows) - min(rows) + 1 if rows else 0), dark, inside


def _spread(values):
    lo, hi = min(values), max(values)
    return (hi - lo) / hi if hi > 0 else 0


def measured_ramps(who, talk):
    if not talk:
        print(f"  {who}: no talk poses declared")
        return {}

    """Order every mouth set closed -> widest, using whichever metric separates
    this character's visemes more cleanly."""
    scored = {name: [_measure(who, m) for m in pose["mouths"]]
              for name, pose in talk.items()}

    best, chosen = None, 0
    for metric in (0, 1, 2):
        widest = {max(range(len(v)), key=lambda i: v[i][metric]) for v in scored.values()}
        spread = sum(_spread([x[metric] for x in v]) for v in scored.values()) / len(scored)
        # Fewest disagreements about which viseme is widest wins; ties go to
        # whichever has more dynamic range to work with.
        score = (-len(widest), spread)
        if best is None or score > best:
            best, chosen = score, metric

    print(f"  {who}: using the {['warm-span', 'dark-cavity', 'mouth-interior'][chosen]} "
          f"metric (agreement {-best[0]}, spread {best[1]:.2f})")
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
# --------------------------------------------------------------------------
# Max - MaxALERT. A blue macaw with the same bones as the BonziBUDDY pair:
# full-body frames with viseme patches registered to eight of them. Everything
# he does is done with his wings.
# --------------------------------------------------------------------------
MAX = {
    "rest":        (rng(126, 137), 8, True),
    "blink":       ([137, (137, 138), (137, 139), (137, 138), 137], 14, False),
    "settle":      (rng(233, 244), 8, True),
    "lookAround":  (rng(223, 229), 10, False),
    "greet":       (rng(147, 155), 12, False),
    "cheer":       (rng(257, 270), 14, False),
    "flap":        (rng(156, 165), 14, True),
    "announce":    (rng(11, 17), 12, False),
    "gesture":     (rng(38, 43), 12, False),
    "explain":     (rng(64, 69), 12, False),
    "point":       (rng(77, 82), 12, False),
    "excited":     (rng(90, 95), 12, False),
    "flourish":    (rng(245, 249), 10, False),
    "wingsOut":    (rng(219, 222), 10, False),
    "arrive":      (rng(204, 218), 14, False),
    "depart":      (rng(109, 124), 14, False),
}

MAX_TALK = {
    "neutral":  {"body": 30,  "mouths": rng(31, 37)},
    "announce": {"body": 17,  "mouths": rng(18, 24)},
    "gesture":  {"body": 43,  "mouths": rng(44, 50)},
    "aside":    {"body": 56,  "mouths": rng(57, 63)},
    "explain":  {"body": 69,  "mouths": rng(70, 76)},
    "point":    {"body": 82,  "mouths": rng(83, 89)},
    "excited":  {"body": 95,  "mouths": rng(96, 102)},
}

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

for name, clips, talk in [("peedy", PEEDY, PEEDY_TALK), ("bonzi", BONZI, BONZI_TALK),
                          ("max", MAX, MAX_TALK)]:
    # Bonzi is optional; skip anyone whose sprites haven't been imported.
    if not os.path.isdir(f"assets/{name}/rgba") and not os.path.isdir(
            f"app/Resources/characters/{name}/frames"):
        print(f"{name}: no sprites imported, skipping")
        continue
    build(name, clips, talk)
