# SNES Buddies

One of the three apps in this repository. See the [repository README](../README.md)
for the others, and for the engine they share.

Twenty Super Nintendo characters who live on your macOS desktop. They pace the
length of the screen at their own speeds, do the things their games had them do,
and talk about video games up to 1997 and nothing after.

```bash
./build.sh snes-buddies && open "build/SNES Buddies.app"
```

![The twenty, at the sizes they stand at next to each other](img/snes-buddies.png)

| | |
|---|---|
| Nintendo | Mario, Luigi, Kirby, Samus, the last Metroid |
| Rare | Donkey Kong, Diddy, Dixie, Squawks |
| Konami | Simon Belmont, Richter Belmont, and the four Turtles |
| Capcom, Namco, Shiny | Mega Man X, Guy, Pac-Man, Earthworm Jim and the worm inside him |

`python3 tools/lineup.py snes-buddies` regenerates the picture above.

MegaDrive Buddies is thirty-seven characters, but they arrived a franchise at a
time — four Streets of Rage sheets in one layout, then the Sonic games, then the
rest of the shelf. This is twenty characters from sixteen games acquired at
once, and the difference shows in how little generalises.

## Two cutters, and neither one wins

`sheet.py` finds horizontal bands of content, then columns within each band.
That is the right shape for a rip laid out in generous rows and it is still the
first thing to try, because the bands come out in reading order and map onto
animations for free.

It fails outright on two layouts, and both are in this cast:

**Packed.** Sprites sit close enough that no fully-background row or column
separates them, so one band swallows the sheet. Chrono Trigger's Crono cuts to
19 frames on a 483x659 canvas — the sheet, essentially, in three pieces.

**Boxed.** Every frame is drawn inside a panel, or captions sit on coloured
bars, and that chrome is continuous across the whole image. Mega Man X cuts to
**exactly one frame**, 1420x3294, because the panel borders join every sprite on
the sheet into a single run of content.

So `tools/blobs.py` cuts from connected components instead: key out the
background *and the chrome*, dilate by a few pixels so a sprite's detached parts
rejoin, label what is left, and take each component's bounding box back on the
undilated pixels. Mega Man X goes from 1 frame to 1,988, and Samus's 6496x4384
sheet cuts in five seconds in pure Pillow, because the labelling runs over
run-length rows rather than pixels.

Neither is better. Link's sheet is dense enough that dilation welds him solid —
`blobs.py` returns 42 frames where `sheet.py` returns 363 — and Ness is the same
story. Which tool suits a sheet is a property of the sheet.

## Dilation is per sheet, not per pipeline

Turtles in Time disproves the idea of a default inside a single game.

Two neighbouring frames on Leonardo's sheet sit close enough that `--gap 3`
welds *them* together, so his eight-frame walk cut as seven with a double turtle
in the middle. Dropping to `--gap 1` — no dilation at all — splits them cleanly.

Run that on Michelangelo and he loses his nunchucks. They hang a pixel clear of
his hands, and without dilation they become eleven little orange splinters with
frame numbers of their own.

Leonardo, Raphael and Donatello are cut at 1; Michelangelo at 3. Same game, same
artists, same year. The gap is not a property of the tool or the console, it is
how close that particular artist put that particular sprite to its neighbour.

Pac-Man needed `--gap 1` for the opposite reason: his frames are boxed, and once
the box colours are keyed the dilation reaches across where the box edge used to
be and joins whole rows. At 3 he cuts to 213 frames, most of them two or three
Pac-Men wide; at 1, to 1,426 clean ones.

## Captions are frames, and nothing catches them

Every sheet here labels its animations, and a label segments exactly like a
sprite. On the Super Mario World sheet the captions land on their own rows,
which is harmless. On Samus's they outnumber the sprites — 917 of her components
are text. On Simon's they sit mid-row, between the walk and the whip.

Mario and Luigi come off the same All-Stars sheet in the same order. Frames 9
through 33 are identical between them, so copying the block across looks right,
and *is* right — until `victory`. Mario's is 45.

At 45, Luigi has the word **Hold**.

The frame exists, it is a plausible size, and it sits in the row the walk came
from. Every automated check passed. What found it was rendering the clips and
looking at them, which is what `tools/clips.py` is for:

```bash
python3 tools/blobs.py mario assets/snes/mario.png \
  --keys "0,148,148;0,84,84;0,116,116;0,52,52" --gap 3 --max 90
python3 tools/index.py mario      # what is on the sheet
python3 tools/catalog.py          # author the ranges
python3 tools/clips.py mario      # what the ranges actually play  <- look here
python3 tools/tighten.py mario
```

`index.py` answers what is on the sheet. `clips.py` answers whether the ranges
landed where they were meant to. They fail differently, and three of the first
twelve were wrong in ways the index could not show:

- **Luigi's `victory`** was the caption "Hold".
- **DK's walk** started at 72, the upright stance he pushes off from, so the
  loop dropped a standing frame into the gait once a cycle. It starts at 73.
- **Dixie's run** included frame 65, two sprites the cutter had joined, so a
  second Dixie flashed past once a cycle.

It caught two more on the way in: Guy's "punch" was three frames of a flying
knee, and Raphael's "attack" opened on him rolled up inside his shell.

## Rows that overlap

Guy's idle row and his run row sit close enough vertically to share a band, and
a band is read left to right — so the frames interleave: 16, 18, 20 standing;
17, 19, 21 sprinting, all the way along. Taking 16–23 as a walk would have him
flickering between standing still and running.

Nothing in the output says so. The frames are all valid, all a sensible size,
all in one band with sequential numbers. It is visible only in the heights —
85 to 89 pixels standing, 75 to 80 running — and in the picture.

## Nobody is the same size

Mario's idle sprite is 20 pixels tall and Guy's is 87. Scaled by one number,
either Mario is under a centimetre or Guy fills a quarter of the screen, so
`scale` is set per character to a target height. The relative order is kept —
Kirby small, Donkey Kong big — but the extremes are pulled in, because a desktop
is not a diorama and Mario still has to be clickable.

| | sprite | scale | on screen | speed |
|---|---|---|---|---|
| Mario | 20px | 4.2 | 97px | 220 pt/s |
| Kirby | 24px | 3.4 | 94px | 170 pt/s |
| Pac-Man | 30px | 3.5 | 121px | 200 pt/s |
| Mega Man X | 34px | 2.8 | 109px | 260 pt/s |
| Donkey Kong | 38px | 3.2 | 140px | 130 pt/s |
| Richter | 44px | 2.6 | 132px | 150 pt/s |
| Leonardo | 60px | 2.0 | 138px | 175 pt/s |
| Metroid | 86px | 1.6 | 158px | 90 pt/s |
| Guy | 87px | 1.3 | 130px | 250 pt/s |

Mega Man X is quick because his eight-frame cycle is a *run* in the game, and
playing a run at walking pace makes him skate — the moonwalking problem from the
other side. Jim out of his suit is the slowest of the twenty, because his crawl
is eight frames of whole-body effort and moving him at any speed makes the
effort look free.

## Three of them have no walk

Squawks flies, with a takeoff and a landing his sheet actually provides. The
last Metroid floats: it has no legs, so its travel is the same membrane pulse
that serves as its idle, stepped across three body sizes. Jim, out of the suit,
is a worm and squirms.

## Two Earthworm Jims and eight Turtles

MegaDrive Buddies already has a `jim` — Earthworm Jim 2, on the Mega Drive — and
`leonardo` and the other three from The Hyperstone Heist. This cast has the SNES
versions of all five, from different rips of different games.

Ids have to be unique across the roster even when products don't overlap, so the
SNES Turtles are `leo`, `raph`, `mikey` and `donnie`, and the SNES Earthworm Jim
is `ewj`. They keep their full names as titles, because no product shows both
sets at once. The worm inside the suit is `jimworm`, titled **Jim (No Suit)** —
the same treatment `earltje` gets for being the second Earl.

## Who didn't make it

Link, Crono, Ness and Randi were cut, rendered and dropped. Their rips are
dominated by front and back views — these are top-down games, and Link's sheet
has no clean side-facing walk at all. A character who walks towards the viewer
while travelling sideways reads as broken, and the fix would have been to pick a
worse animation for a better-known face.
