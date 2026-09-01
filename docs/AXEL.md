# Axel — a different kind of buddy

Branch `axel`. Adds Axel Stone from *Streets of Rage 2* as a third character,
and in doing so establishes that the app can host something other than a
Microsoft Agent character.

He is not a variation on Peedy and Bonzi. He's a beat-'em-up sprite rip, and
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
Axel's sheet gives 162 frames across 19 bands, which map almost one-to-one onto
animations — idle, walk, jab, kick, the Grand Upper, knockdown, and the portrait
art at the end.

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
