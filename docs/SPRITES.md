# About the sprites

The character artwork under `app/Resources/characters/` is **not covered by this
project's MIT licence**.

Peedy (the parrot) and Bonzi (the gorilla) are Microsoft Agent characters. The
artwork belongs to its respective owners — Microsoft for the Agent character
set, and Bonzi Software for Bonzi. It is included here so the app runs straight
from a clone, but no rights to the characters are granted with it, and it is not
mine to license.

The MIT licence in `LICENSE` covers the Swift source, the Python tooling, and
the documentation.

**If you are a rights holder** and would like this removed, open an issue or
contact the maintainer and it will be taken down promptly.

## What's committed, and what isn't

| | |
|---|---|
| `app/Resources/characters/<name>/frames/` | The packed sprites the app loads — trimmed, alpha-keyed PNGs. Committed. |
| `app/Resources/characters/<name>/frames.json` | Frame offsets, so trimmed frames stay registered with each other. Committed. |
| `app/Resources/characters/<name>/animations.json` | Clip ranges, frame rates, talk poses, viseme ramps. Committed. |
| `assets/` | The raw sprite dumps and the keyed intermediates. **Not committed** — 35 MB, and regenerable. |

## Rebuilding the asset pack

You only need this if you're changing the pipeline or adding a character. The
source dumps are widely archived as "BonziBUDDY - Characters - Peedy" and
"- Bonzi", each a zip of numbered PNG frames on a cyan (`#00FFFF`) background.

```bash
./setup.sh ~/Downloads/peedy.zip ~/Downloads/bonzi.zip
```

That unpacks them, keys out the cyan, trims every frame, measures the visemes,
writes the asset pack, and builds the app.

## Adding your own character

1. Get a sprite dump on a flat colour-key background.
2. `python3 tools/extract.py <name>` — keys it out, measures every frame.
3. `python3 tools/strips.py <name>` — renders labelled contact strips into
   `sheets/`. Runs of full-body frames are almost always one animation each;
   the small patches between them are mouth visemes and eye blinks.
4. Declare the clip ranges and talk poses in `tools/catalog.py`.
5. `python3 tools/pack.py <name>` — writes the asset pack.
6. Add a `Personality` in `app/Sources/` — voice, pacing, clips, and what they say.
7. Add exchanges to `Banter.swift` if they should talk to the others.

`tools/casttest` will tell you if you've named a clip that doesn't exist.
