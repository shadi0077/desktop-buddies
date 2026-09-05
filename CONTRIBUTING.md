# Contributing

Thanks for looking. This is a small project with a clear shape — one engine and
two apps built out of it — so a bit of orientation goes a long way.

## Getting it running

You need macOS and the Xcode command line tools. The sprites are committed, so
a clone builds and runs directly:

```bash
./build.sh                          # both apps
./build.sh desktop-buddies          # just one
open "build/Desktop Buddies.app"
```

There is no Xcode project. `build.sh` compiles the sources with `swiftc` and
assembles each `.app` itself.

`./setup.sh` rebuilds a character's asset pack from the source artwork —
`agent` for the Microsoft Agent dumps, `sheet` for a game sprite sheet. Only
needed if you're changing the pipeline or adding a character; see
[docs/SPRITES.md](docs/SPRITES.md).

## Before you open a PR

```bash
./test.sh
```

Everything should pass. It takes about fifteen minutes, almost all of it
rendering real audio — every line of every speech pack, in both languages.
`SKIP_AUDIO=1 ./test.sh` runs the rest in seconds, which is what CI does.

`PEEDY_DEBUG=1` / `BUDDY_DEBUG=1` traces behaviour decisions to stderr, and
`PEEDY_TURN` / `BUDDY_TURN` runs one thing on launch rather than waiting for the
idle rotation to pick it — `song`, `joke`, `fact`, `riddle`, `twister`, `banter`
for the cartoons, `fight` for the sprites:

```bash
PEEDY_DEBUG=1 PEEDY_TURN=song "./build/Desktop Buddies.app/Contents/MacOS/Desktop Buddies"
BUDDY_DEBUG=1 BUDDY_TURN=fight "./build/MegaDrive Buddies.app/Contents/MacOS/MegaDrive Buddies"
```

`BUDDY_PRODUCT=<id>` points the test tools at a product without rebuilding, and
`BUDDY_APP=<path>` at a specific bundle.

## What tends to go wrong

Five failure modes have bitten repeatedly. If you're changing anything nearby,
these are worth knowing:

**Overlay patches only fit one body frame.** Mouth visemes and eye blinks are
small patches registered to exactly one pose. Composite one onto any other frame
and you get a rectangle of beak floating in the middle of the wrong body.
`Animator.render()` enforces this and `tools/talktest` proves it.

**A clip that doesn't exist is silent, not loud.** The game rips don't cover the
same ground: the Streets of Rage 2 four have a dozen moves each, an enemy sprite
has three. Naming a clip directly means a character without it performs nothing
at all — Axel spent an afternoon doing `cheer`, which he hasn't got. Shared
routines go through `Brain.move(_:)`, which drops what a character lacks and
falls back to its own flourishes. `tools/casttest` and `tools/gamecasttest` fail
on any clip named in a `Personality` that the sprite set doesn't have.

**Long sequences hand back through deferred callbacks.** A "bit" — reading a
newspaper, or guard-then-punch — owns its character across intro, loop and
outro. Drop the callback and the character is stranded mid-bit forever. Every
such sequence carries a generation token, and `Brain.tick` has a 60-second
backstop because this has genuinely happened three times. The third was a
looping clip used as a flourish: `Animator.play` only calls back for a clip that
*finishes*, so Sonic performed his run cycle and stood there running for a
minute. Play clips through `Brain.playOnce`, never `animator.play`, unless you
are handling the loop yourself.

**Measure audio, don't trust it.** Pitch detectors octave-double;
`engine.isRunning` is true when nothing is rendering;
`AVSpeechUtterance.pitchMultiplier` does not make a synthesiser sing; and
`AVAudioPlayer.play()` makes a blocking XPC call to the audio server, so it must
never run on the main thread — a test that played a hundred clips in a row
wedged `coreaudiod` and left the app looking dead. Anything to do with sound has
a test that measures the actual samples, and `tools/dsptest` validates the
signal processing against synthetic signals whose answer is known.

**A sprite sheet is not as regular as it looks.** Captions land inside frames at
a perfectly normal size, colour swatches sit among the sprites, one column can
hold two stacked sprites, MS Paint marker bars weld two cells together, and the
Streets of Rage 1 rips have no whole-body walk. None of it is detectable from
frame sizes. Render `tools/index.py` and look before authoring ranges, and read
the traps listed in [docs/megadrive-buddies.md](docs/megadrive-buddies.md).

## Adding a character

Which pipeline depends on which app. Both are written out step by step in
[docs/SPRITES.md](docs/SPRITES.md) — Microsoft Agent dumps go through
`extract.py` / `strips.py` / `pack.py`, game sheets through `sheet.py` /
`index.py`. Either way it ends the same:

1. Declare the clip ranges in `tools/catalog.py` and run it.
2. Add a `Personality` — `Personality.everyone` is the register.
3. Give them something to say: `Banter.swift` and their own `<Name>Personality`
   for the cartoons, `GameTalk.swift` for the sprites, where a test enforces a
   minimum of lines only they would say.
4. List them in the `cast` of whichever `products/*.json` should ship them. A
   character in no product's cast is compiled but never appears.
5. Give them a menu-bar frame in their catalogue entry if their sheet has
   portrait art — it reads much better at 18pt than an action frame.

One sheet is cut with nothing authored for it, and it's the interesting one:

`headdy` — Dynamite Headdy. His sheet is sectioned BODY 1 and HEAD 1, and it
contains no complete figure anywhere: every sprite is a part. Compositing does
look right — try body 21 with head 61 — but shipping him needs a per-frame
pairing of head to body and a step that renders the composites into a normal
frame pack. That's authoring rather than cutting, which is why he isn't in.

## Adding an app

A product is a manifest in `products/`: an id, a name, a bundle identifier and a
cast. Copy one, run `python3 tools/icon.py <id>` and `./build.sh <id>`. No
target, no project file, and nothing in the Swift sources needs to know it
exists — `Product.swift` reads the bundled copy at runtime, and `Product.isSilent`
decides on its own whether the app gets voice controls or fight controls.

## Style

Match the surrounding code. Comments explain *why*, especially where something
looks odd — most of the odd-looking code is odd because the obvious version was
measured and found wanting.
