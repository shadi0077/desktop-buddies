"""Curate a character's sound effects into the app bundle.

Usage: sounds.py <character> <source-dir>

The Streets of Rage rip names voice clips V00..V52 and effects 00..49, with no
index of what each one is. Nobody wrote down which grunt is which, so the
grouping here is by that naming convention plus duration — short voice clips
are exertion, short effects are impacts, longer voice clips are shouts. It's an
inference, not a transcription.
"""
from pathlib import Path
import json, shutil, sys, wave

name, src = sys.argv[1], Path(sys.argv[2])
out = Path(f"app/Resources/characters/{name}/sounds")
if out.is_dir():
    shutil.rmtree(out)
out.mkdir(parents=True, exist_ok=True)


def seconds(p):
    try:
        with wave.open(str(p)) as w:
            return w.getnframes() / w.getframerate()
    except Exception:
        return None


groups = {"effort": [], "impact": [], "shout": []}
for p in sorted(src.glob("*.wav")):
    d = seconds(p)
    if d is None or d < 0.08 or d > 2.2:
        continue                      # jingles and music stings aren't wanted
    voice = p.stem.upper().startswith("V")
    if voice and d <= 0.9:
        groups["effort"].append(p)
    elif voice:
        groups["shout"].append(p)
    elif d <= 0.7:
        groups["impact"].append(p)

# A handful from each is plenty; too many and nothing feels characteristic.
manifest = {}
for group, paths in groups.items():
    keep = paths[:14]
    manifest[group] = []
    for i, p in enumerate(keep):
        target = f"{group}{i:02d}.wav"
        shutil.copy(p, out / target)
        manifest[group].append(target)

json.dump(manifest, open(f"app/Resources/characters/{name}/sounds.json", "w"), indent=1)
total = sum(f.stat().st_size for f in out.iterdir())
print(f"{name}: " + ", ".join(f"{len(v)} {k}" for k, v in manifest.items())
      + f"  ({total/1024:.0f} KB)")
