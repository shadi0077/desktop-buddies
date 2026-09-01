# Contributing

Thanks for looking. This is a small project with a clear shape, so a bit of
orientation goes a long way.

## Getting it running

You need macOS and the Xcode command line tools. The sprites are committed, so
a clone builds and runs directly:

```bash
./build.sh && open "build/Desktop Buddies.app"
```

`./build.sh` builds both apps; pass `desktop-buddies` or `megadrive-buddies` to
build just one. `./setup.sh <peedy.zip> <bonzi.zip>` rebuilds the asset pack from
the raw sprite dumps — only needed if you're changing the pipeline or adding a
character.

There is no Xcode project. `build.sh` compiles the sources with `swiftc` and
assembles the `.app` itself.

## Before you open a PR

```bash
./test.sh
```

Everything should pass. It takes a couple of minutes, mostly because the speech
tests render real audio.

`PEEDY_DEBUG=1` traces behaviour decisions to stderr, and `PEEDY_TURN=song`
(or `joke`, `fact`, `riddle`, `twister`, `banter`) runs that on launch rather
than waiting for the idle rotation to pick it:

```bash
PEEDY_DEBUG=1 PEEDY_TURN=song "./build/Desktop Buddies.app/Contents/MacOS/Desktop Buddies"
```

`BUDDY_PRODUCT=<id>` points the test tools at a product without rebuilding, and
`BUDDY_APP=<path>` at a specific bundle.

## What tends to go wrong

Three failure modes have bitten repeatedly. If you're changing anything nearby,
these are worth knowing:

**Overlay patches only fit one body frame.** Mouth visemes and eye blinks are
small patches registered to exactly one pose. Composite one onto any other frame
and you get a rectangle of beak floating in the middle of the wrong body.
`Animator.render()` enforces this and `tools/talktest` proves it.

**Long sequences hand back through deferred callbacks.** A "bit" — reading,
sunglasses, a song — owns its character across intro, loop and outro. Drop the
callback and the character is stranded mid-bit forever. Every such sequence
carries a generation token, and `Brain.tick` has a 60-second backstop because
this has genuinely happened twice.

**Measure audio, don't trust it.** Pitch detectors octave-double; `engine.isRunning`
is true when nothing is rendering; `AVSpeechUtterance.pitchMultiplier` does not
make a synthesiser sing. Anything to do with sound has a test that measures the
actual samples, and `tools/dsptest` validates the signal processing against
synthetic signals whose answer is known.

## Adding a character

1. Get a sprite dump on a flat colour-key background.
2. `python3 tools/extract.py <name>` keys it out and measures every frame.
3. `python3 tools/strips.py <name>` renders labelled contact strips into
   `sheets/` — runs of full-body frames are almost always one animation each.
4. Declare the clip ranges and talk poses in `tools/catalog.py`.
5. `python3 tools/pack.py <name>` writes the asset pack.
6. Add a `Personality` to `Personality.everyone` — voice, pacing, clips, and
   what they say.
7. Add exchanges to `Banter.swift` if they should talk to the others.
8. List them in the `cast` of whichever `products/*.json` should ship them. A
   character in no product's cast is compiled but never appears.

Characters from a single game sprite sheet go through `tools/sheet.py` instead
of steps 2–3; see [docs/MEGADRIVE.md](docs/MEGADRIVE.md).

`tools/casttest` will tell you if you've named a clip that doesn't exist. It
runs once per product, so a clip only one cast has can't become a requirement
for all of them.

## Adding an app

Copy a manifest in `products/`, give it an `id`, `name`, `bundleID` and `cast`,
then `python3 tools/icon.py <id>` and `./build.sh <id>`. No target, no project
file, and nothing in the Swift sources needs to know it exists.

## Style

Match the surrounding code. Comments explain *why*, especially where something
looks odd — most of the odd-looking code is odd because the obvious version was
measured and found wanting.
