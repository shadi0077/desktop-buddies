"""Checks the written content that don't need the sprites, so CI can run them.

Verifies the two characters stay distinct and that nothing in the dialogue
refers to a character or an animation that no longer exists.
"""
import re
import sys
from pathlib import Path

SRC = Path("app/Sources")
failures = []


def check(label, ok, detail=""):
    print(f"  {'ok  ' if ok else 'FAIL'}  {label}{'  ' + detail if detail and not ok else ''}")
    if not ok:
        failures.append(label)


def swift(name):
    return (SRC / name).read_text()


# Animation names the catalogue declares, per character.
catalog = Path("tools/catalog.py").read_text()


def clip_names(block):
    section = catalog.split(f"{block} = {{", 1)[1].split("\n}", 1)[0]
    names = set(re.findall(r'^\s*"([A-Za-z0-9]+)":', section, re.M))
    for new, src in re.findall(r'\("(\w+)", "(\w+)"\)', catalog):
        if src in names:
            names.add(new)
    return names


peedy_clips = clip_names("PEEDY") | {"headphonesOff", "sunglassesOff", "readEnd",
                                     "writeEnd", "searchEnd"}
bonzi_clips = clip_names("BONZI") | {"readEnd", "globeEnd"}
check("catalogue declares clips for Peedy", len(peedy_clips) > 20, str(len(peedy_clips)))
check("catalogue declares clips for Bonzi", len(bonzi_clips) > 20, str(len(bonzi_clips)))

# Every gesture used in dialogue must exist for whoever performs it.
banter = swift("Banter.swift")
lines = re.findall(r'BanterLine\("(\w+)",\s*"((?:[^"\\]|\\.)*)"(?:,\s*"(\w+)")?\)', banter)
check("dialogue has lines", len(lines) > 30, str(len(lines)))
known = {"peedy": peedy_clips, "bonzi": bonzi_clips}
bad = [f"{who}:{move}" for who, _, move in lines if move and move not in known.get(who, set())]
check("every dialogue gesture exists for its speaker", not bad, ", ".join(bad))
check("dialogue only names known characters",
      all(who in known for who, _, _ in lines))

# The personalities must not quietly converge into the same character.
peedy_src, bonzi_src = swift("PeedyPersonality.swift"), swift("BonziPersonality.swift")


def pool(src, field):
    body = src.split(f"{field}: [", 1)[1]
    depth, out = 1, []
    for i, ch in enumerate(body):
        if ch == "[":
            depth += 1
        elif ch == "]":
            depth -= 1
            if depth == 0:
                out = body[:i]
                break
    return set(re.findall(r'"((?:[^"\\]|\\.)*)"', out))


for field in ["greetings", "idle", "poked", "dropped", "leaving"]:
    shared = pool(peedy_src, field) & pool(bonzi_src, field)
    check(f"no shared {field}", not shared, ", ".join(list(shared)[:3]))

check("no shared jokes",
      not (set(re.findall(r'setup: "((?:[^"\\]|\\.)*)"', peedy_src))
           & set(re.findall(r'setup: "((?:[^"\\]|\\.)*)"', bonzi_src))))
check("Bonzi speaks more slowly",
      float(re.search(r"rate: ([\d.]+)", bonzi_src).group(1))
      < float(re.search(r"rate: ([\d.]+)", peedy_src).group(1)))
check("they sing in different registers",
      float(re.search(r"singingRoot: (\d+)", bonzi_src).group(1))
      != float(re.search(r"singingRoot: (\d+)", peedy_src).group(1)))

# Every menu string the app asks for must exist in every language, or the menu
# comes out half translated — which is worse than not translating it at all.
lang_src = swift("Language.swift")
arabic_keys = set(re.findall(r'^\s*"([^"]+)":', lang_src, re.M))
used = set()
for name in ["AppDelegate.swift"]:
    src = swift(name)
    used |= set(re.findall(r'\bt\("((?:[^"\\]|\\.)*)"\)', src))
# Menu levels are localised through the same table.
for enum_field in re.findall(r'case \.\w+: return "([^"]+)"', swift("Brain.swift")):
    used.add(enum_field)
for enum_field in re.findall(r'case \.\w+: return "([^"]+)"', swift("Voice.swift")):
    used.add(enum_field)
for enum_field in re.findall(r'case \.\w+: return "([^"]+)"', swift("AppDelegate.swift")):
    used.add(enum_field)
missing = sorted(k for k in used if k not in arabic_keys)
check("every menu string has an Arabic translation", not missing,
      ", ".join(missing[:6]))
print(f"        {len(used)} strings used, {len(arabic_keys)} translated")

# Both characters must be able to speak both languages.
for who, src in [("Peedy", peedy_src), ("Bonzi", bonzi_src)]:
    ar = swift(f"{who}Arabic.swift")
    check(f"{who} has an Arabic pack", "SpeechPack(" in ar)
    # Arabic packs must actually contain Arabic.
    arabic_chars = sum(1 for ch in ar if "\u0600" <= ch <= "\u06ff")
    check(f"{who}'s Arabic pack is written in Arabic", arabic_chars > 2000,
          f"{arabic_chars} Arabic characters")

print("\nall checks passed" if not failures else f"\n{len(failures)} FAILED")
sys.exit(0 if not failures else 1)
