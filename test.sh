#!/bin/bash
# Checks for the pure logic, plus headless renders into shots/ so the sprite
# work can be eyeballed without needing screen-recording permission.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build shots

APPKIT="-framework AppKit -framework ServiceManagement -framework AVFoundation"
CORE="app/Sources/SpriteStore.swift app/Sources/BuddyView.swift app/Sources/SpeechBubble.swift"
CONTENT="app/Sources/Language.swift app/Sources/Chatter.swift app/Sources/Repertoire.swift
         app/Sources/Personality.swift
         app/Sources/PeedyPersonality.swift app/Sources/PeedyArabic.swift
         app/Sources/BonziPersonality.swift app/Sources/BonziArabic.swift"
ENGINE="app/Sources/Animator.swift app/Sources/BuddyWindow.swift app/Sources/Voice.swift
        app/Sources/Brain.swift"

echo "== deployment target =="
./build.sh >/dev/null
PLIST_MIN=$(/usr/libexec/PlistBuddy -c "Print :LSMinimumSystemVersion" app/Info.plist)
BIN_MIN=$(otool -l build/Peedy.app/Contents/MacOS/Peedy | awk '/LC_BUILD_VERSION/{f=1} f&&/minos/{print $2; exit}')
ARCH=$(lipo -info build/Peedy.app/Contents/MacOS/Peedy | sed 's/.*: //')
echo "  Info.plist $PLIST_MIN / binary $BIN_MIN / $ARCH"
# macOS 11 is the first release that ran on Apple Silicon.
[ "$PLIST_MIN" = "11.0" ] || { echo "  FAIL Info.plist minimum is $PLIST_MIN, expected 11.0"; exit 1; }
[ "$BIN_MIN" = "11.0" ] || { echo "  FAIL binary minos is $BIN_MIN, expected 11.0"; exit 1; }
case "$ARCH" in *arm64*) ;; *) echo "  FAIL missing arm64 slice"; exit 1;; esac
echo "  ok   runs on every macOS that has shipped on Apple Silicon"

echo
echo "== written content =="
python3 tools/lint_content.py

echo
echo "== pitch resynthesis =="
swiftc -O -framework AVFoundation -framework AppKit \
  app/Sources/Language.swift app/Sources/Repertoire.swift app/Sources/Voice.swift \
  tools/dsptest/main.swift -o build/dsptest
./build/dsptest

echo
echo "== the cast =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Banter.swift \
  tools/casttest/main.swift -o build/casttest
./build/casttest

echo
echo "== wander logic =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE tools/wandertest/main.swift -o build/wandertest
./build/wandertest

echo
echo "== liveliness =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE tools/alivetest/main.swift -o build/alivetest
./build/alivetest

echo
echo "== lip-sync registration =="
swiftc -O -framework AppKit $CORE app/Sources/Animator.swift \
  tools/talktest/main.swift -o build/talktest
for who in peedy bonzi; do echo "-- $who"; ./build/talktest "$who"; done

# Speech and singing render real audio. That works headlessly, but a CI runner
# with no audio device at all is a different matter, so it can opt out.
if [ "${SKIP_AUDIO:-0}" = "1" ]; then
  echo
  echo "== voice and singing: skipped (SKIP_AUDIO=1) =="
  echo
  echo "== headless renders =="
  swiftc -O -framework AppKit $CORE tools/render/main.swift -o build/render
  for who in peedy bonzi; do ./build/render build/Peedy.app "$who" >/dev/null; done
  echo "sheets in shots/"
  exit 0
fi

echo
echo "== voice, visemes and icons =="
swiftc -O -framework AppKit -framework AVFoundation \
  app/Sources/SpriteStore.swift app/Sources/Repertoire.swift app/Sources/Voice.swift \
  app/Sources/Language.swift app/Sources/Personality.swift \
  app/Sources/PeedyPersonality.swift app/Sources/PeedyArabic.swift \
  app/Sources/BonziPersonality.swift app/Sources/BonziArabic.swift \
  tools/voicetest/main.swift -o build/voicetest
for who in peedy bonzi; do echo "-- $who"; ./build/voicetest "$who"; done

echo
echo "== repertoire and singing =="
swiftc -O -framework AppKit -framework AVFoundation \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Voice.swift \
  tools/songtest/main.swift -o build/songtest
for who in peedy bonzi; do
  for lang in en ar; do echo "-- $who/$lang"; ./build/songtest "$who" "$lang"; done
done

echo
echo "== Arabic reads cleanly =="
swiftc -O -framework AVFoundation -framework AppKit \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Voice.swift \
  tools/arabictest/main.swift -o build/arabictest
./build/arabictest

echo
echo "== audio device churn =="
swiftc -O -framework AVFoundation -framework AppKit \
  app/Sources/Language.swift app/Sources/Repertoire.swift app/Sources/Voice.swift \
  tools/iotest/main.swift -o build/iotest
./build/iotest

echo
echo "== right-to-left text =="
swiftc -O -framework AppKit app/Sources/SpeechBubble.swift tools/rtltest/main.swift \
  -o build/rtltest
./build/rtltest

echo
echo "== volume slider =="
swiftc -O -framework AppKit app/Sources/VolumeSlider.swift tools/uitest/main.swift -o build/uitest
./build/uitest

echo
echo "== headless renders =="
swiftc -O -framework AppKit $CORE tools/render/main.swift -o build/render
for who in peedy bonzi; do ./build/render build/Peedy.app "$who" >/dev/null; done
swiftc -O -framework AppKit -framework AVFoundation \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Voice.swift \
  app/Sources/BuddyView.swift tools/lipsync/main.swift -o build/lipsync
./build/lipsync
echo "sheets in shots/"
