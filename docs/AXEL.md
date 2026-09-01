# Streets of Rage — a different kind of buddy

Branch `axel`. Adds the Streets of Rage 2 playable roster — **Axel, Blaze, Max
and Skate** — and in doing so establishes that the app can host something other
than a Microsoft Agent character.

They are not variations on Peedy and Bonzi. He's a beat-'em-up sprite rip, and
almost everything that makes the other two work does not apply to him:

| | Peedy / Bonzi | Axel |
|---|---|---|
| Source | numbered PNG frames, one per file | one 696×1688 sheet |
| Background | cyan `#00FFFF` | light green `#CCFFCC` |
| Mouth frames | seven visemes per pose | none |
| Expression | speech, lip-synced to the audio | game sound effects |
| Scaling | smoothed — they're 3D renders | nearest-neighbour — pixel art |
| Blinking | eye patches, own clock | no blink frames at all |

## Cutting the sheet

`tools/sheet.py` segments a sheet into frames: find horizontal bands of
content, then columns within each band, then trim each to its own bounding box.
The four sheets give 162, 186, 150 and 137 frames, and their bands map almost
one-to-one onto animations — idle, walk, jab, kick, the Grand Upper, knockdown,
and the portrait art at the end.

One trap worth knowing: a caption printed directly above a sprite ends up
*inside* that frame, because the band containing both is one run of content.
Those frames are a normal size, so nothing can filter them out automatically.
Blaze's walk cycle starts two frames later than it looks like it should for
exactly this reason, and the only way to catch it is to render the numbered
index and look.

Frames are anchored bottom-centre on a shared canvas so his feet stay planted.

## Sound instead of speech

`SoundBank` plays short one-shots through `AVAudioPlayer` rather than the engine
the speaking characters use — these want firing and forgetting, and
`AVAudioPlayer.play()` returns false on a dead audio device instead of raising
the uncatchable exception `AVAudioPlayerNode` does.

Every animation makes a fitting noise, chosen by clip name: specials and
celebrations shout, knockdowns thud, everything else grunts.

The rip names voice clips `V00`–`V52` and effects `00`–`49`, with no index of
what each one is — nobody wrote down which grunt is which. The grouping is by
that naming convention plus duration: short voice clips are exertion, short
effects are impacts, longer voice clips are shouts. It's an inference, not a
transcription.

## Moving about

They walk, so they travel at walking pace and go a long way with it. `Roaming`
carries a distance range, a speed in points per second, an arc height and a
restlessness — because a walk cycle played while the window jumps 500 points in
half a second reads as moonwalking, which is what it looked like before this
existed.

| | distance | speed | arc | restlessness |
|---|---|---|---|---|
| Peedy | 160–520 | 620 pt/s | 42 | 1.0 |
| Bonzi | 200–560 | 400 pt/s | 16 | 1.0 |
| Axel | 600–2200 | 165 pt/s | 0 | 2.6 |
| Max | 500–1600 | 120 pt/s | 0 | 1.6 |
| Skate | 900–3000 | 300 pt/s | 0 | 3.4 |

Measured on Axel: 102 position changes over one stretch, 1846 points travelled,
largest single step 38 points.

## What this changed in the engine

Adding him surfaced a pile of assumptions that only held because both existing
characters came from the same sprite set:

- `SpeechPack` is now optional on `Personality`. A character can have none.
- The shared routines named clips like `cheer` and `lookAround` directly. They
  now go through `move(_:)`, which drops any clip the character hasn't got and
  falls back to its own flourishes. Axel was performing `cheer` — a clip that
  doesn't exist — and silently doing nothing.
- Blinking is guarded on the clip existing, rather than assumed.
- Interpolation is per-character, so pixel art isn't blurred.
- A character who doesn't speak no longer constrains which languages are on
  offer.

`tools/casttest` covers all of it, and caught the missing clips itself.
