# Changelog

## 1.5

- **Two apps again, out of one repository.** **Desktop Buddies** is the nine
  Microsoft Agent characters; **MegaDrive Buddies** is thirty-seven Mega Drive
  sprites. Separate names, icons and bundle identifiers, so both run at once
  and keep their own characters, positions, volume and size — but one engine,
  one test suite and one set of tools behind them.
- **Twenty-six more Mega Drive characters** on top of the eleven Streets of
  Rage ones: the Sonic cast and Mecha Sonic, Ristar, the four Hyperstone Heist
  turtles, Earthworm Jim, Pulseman, Sparkster, Donald Duck, ToeJam, Earl,
  Terry Bogard, Robert Garcia, Ryu, Joe Musashi, Gambit, Sketch Turner,
  Michael Jackson, and a third Axel and a fourth Sonic.
- **They talk, in speech bubbles with no voice** — 64 facts, 89 jokes, 72
  passing remarks, 78 two-handers and 120 lines belonging to particular
  characters, all about games up to 1997 and nothing after. The cutoff is
  enforced by a test that scans every line for a later year. Bubbles for the
  sprite cast are square-cornered with a hard shadow; the cartoons keep their
  soft balloons.
- **Sound out of the games themselves** — five rips grouped into effort,
  impact and shout by measuring the audio rather than by trusting filenames,
  because none of the rips say what any of their sounds are.
- **Liveliness** (Calm / Occasional / Restless) is now separate from
  **Chattiness**: pacing about and talking are different appetites.
- `AVAudioPlayer.play()` makes a blocking XPC call to the audio server, so
  sound effects now play off the main thread. Playing a hundred in a row on the
  main thread wedges `coreaudiod` and the app stops drawing entirely.
- The sheet cutter gained a connected-component mode for sheets whose sprites
  don't sit in rows, and learned to ignore MS Paint marker bars — which were
  welding two sprites into one frame.
- `setup.sh` now takes `agent` or `sheet` and runs the matching pipeline.

## 1.4

- **Seven more characters**, all from the same era and the same technology:
  **Max** (MaxALERT) and the Microsoft Office XP assistants **Clippit**,
  **Rover**, **Merlin**, **F1**, **Earl** and **Manma-chan**. Nine in total,
  each with its own voice, pace, singing register, jokes, facts, riddles and
  songs — in English and Saudi Arabic — and none of them sharing a line with
  another.
- Characters whose sprite sets have no mouth patches gesture while they speak
  rather than holding a still pose. Five of the seven are like this: they were
  ripped as finished frames, with no overlays to composite a mouth from.
- **Any two of them can now hold a conversation.** The Peedy and Bonzi
  exchanges stay as they were; every other pairing draws on a set written to
  work in any mouth, so a cast of nine never has two characters with nothing
  to say to each other.
- The menu-bar frame is now part of each character's catalogue rather than a
  list in the app.
- The Streets of Rage characters have been removed, along with the second app
  and everything the engine only had for them.

## 1.3

*Superseded by 1.4, which folded the cast back into one app.*

- **Two apps.** The cast is split in two: **Desktop Buddies** is Peedy and
  Bonzi, and **MegaDrive Buddies** is the eleven Streets of Rage characters.
  Separate bundle identifiers, so both can run at once and keep their own
  characters, positions, volume and size.
- A product is a JSON manifest in `products/` naming a cast. The build copies
  only that cast's sprites — 18 MB and 7 MB rather than 25 MB each — and the app
  filters its roster and its menu to match, so a product where nobody speaks has
  no Language submenu and offers **Let Them Fight** rather than Let Them Chat.
- **Eleven Streets of Rage characters**: Axel, Blaze, Max and Skate from the
  second game, Adam, Axel and Blaze from the first, and Galsia, Donovan, Eagle
  and Slum. They walk rather than fly, use the game's own sound effects instead
  of speech, and fight each other when two get close.
- Characters now travel at their own pace over their own distances, so a walk
  cycle no longer reads as moonwalking.
- The two 1991 characters show as *Axel (1991)* and *Blaze (1991)* rather than
  the raw ids.

## 1.2

- Arabic is now **Saudi (Najdi)** rather than Modern Standard: dialect
  vocabulary and syntax throughout, local jokes, and riddles asked the way
  people ask them. Measured — dialect spelling costs the synthesiser nothing.
- The app prefers an `ar-SA` voice automatically if one is ever installed.
- Fixed a crash when the audio device disappeared and came back mid-session.

## 1.1

- **Arabic.** Both characters speak Modern Standard Arabic with a Gulf warmth,
  switchable from the menu. Written rather than translated: Arabic jokes,
  classic Arabic riddles, original songs. The menu localises too, and speech
  balloons lay out right-to-left.
- macOS ships one Arabic voice, so the two are told apart by pitch and pace.
  A language with no installed voice isn't offered.

## 1.0

First release.

- **Two characters.** Peedy, a quick and fussy parrot; Bonzi, a slow and
  unbothered gorilla. Have either, or both.
- **They talk to each other.** 23 exchanges, running when both are free and both
  have nothing else on.
- **They're alive rather than looping.** Energy that rises with attention and
  decays without it, cursor awareness, independent blinking, poke habituation,
  and awareness of whether you're at the keyboard at all.
- **Speech**, with the mouth driven by the audio's own loudness envelope rather
  than a timer.
- **Singing** — real melodies, in tune, via time-domain PSOLA.
- **A repertoire**: jokes told with a beat before the punchline, true facts,
  riddles, tongue twisters, and public-domain songs.
- **Their own volume**, independent of the system's.
- macOS 11 and later on Apple Silicon.
