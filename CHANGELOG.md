# Changelog

## 1.3

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
