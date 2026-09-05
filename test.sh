#!/bin/bash
# Checks for the pure logic, plus headless renders into shots/ so the sprite
# work can be eyeballed without needing screen-recording permission.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build shots

APPKIT="-framework AppKit -framework ServiceManagement -framework AVFoundation"
CORE="app/Sources/SpriteStore.swift app/Sources/BuddyView.swift app/Sources/SpeechBubble.swift"
# One file per character, picked up by name so adding a character to the cast
# doesn't mean remembering to add it here too.
CHARACTERS=$(ls app/Sources/*Personality.swift app/Sources/*Personalities.swift \
             app/Sources/*Arabic.swift \
             | grep -v '^app/Sources/Personality.swift$' | tr '\n' ' ')
CONTENT="app/Sources/Language.swift app/Sources/Chatter.swift app/Sources/Repertoire.swift
         app/Sources/GameTalk.swift app/Sources/Personality.swift $CHARACTERS"
ENGINE="app/Sources/Animator.swift app/Sources/BuddyWindow.swift app/Sources/Voice.swift
        app/Sources/SoundBank.swift app/Sources/Brain.swift"

# ./test.sh audio plays real sound through the speakers, which the rest of the
# suite deliberately never does: a CI runner has no audio device, and playing
# clips in bulk once wedged this machine's audio server for an hour.
if [ "${1:-}" = "audio" ]; then
    echo "== sound actually reaching the speakers =="
    ./build.sh megadrive-buddies >/dev/null
    swiftc -O -framework AppKit -framework AVFoundation \
      app/Sources/SoundBank.swift tools/soundcheck/main.swift -o build/soundcheck
    BUDDY_APP="build/MegaDrive Buddies.app" ./build/soundcheck
    exit $?
fi

echo "== deployment target =="
./build.sh >/dev/null
APP="build/Desktop Buddies.app"
# The cast, from the manifest, so these loops don't go stale when one is added.
CAST=$(python3 -c "import json;print(' '.join(json.load(open('products/desktop-buddies.json'))['cast']))")
PLIST_MIN=$(/usr/libexec/PlistBuddy -c "Print :LSMinimumSystemVersion" app/Info.plist)
BIN_MIN=$(otool -l "$APP/Contents/MacOS/Desktop Buddies" | awk '/LC_BUILD_VERSION/{f=1} f&&/minos/{print $2; exit}')
ARCH=$(lipo -info "$APP/Contents/MacOS/Desktop Buddies" | sed 's/.*: //')
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
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift \
  app/Sources/Banter.swift tools/casttest/main.swift -o build/casttest
BUDDY_PRODUCT="products/desktop-buddies.json" BUDDY_APP="$APP" ./build/casttest

echo
echo "== the game cast =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift \
  tools/gamecasttest/main.swift -o build/gamecasttest
BUDDY_PRODUCT="products/megadrive-buddies.json" \
  BUDDY_APP="build/MegaDrive Buddies.app" ./build/gamecasttest

echo
echo "== one sprite per frame =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift \
  tools/framestest/main.swift -o build/framestest
BUDDY_PRODUCT="products/megadrive-buddies.json" \
  BUDDY_APP="build/MegaDrive Buddies.app" ./build/framestest

echo
echo "== what the game cast talks about =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift \
  tools/gametalktest/main.swift -o build/gametalktest
BUDDY_PRODUCT="products/megadrive-buddies.json" ./build/gametalktest

echo
echo "== speech bubbles =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift \
  tools/bubbletest/main.swift -o build/bubbletest
./build/bubbletest

echo
echo "== wander logic =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift tools/wandertest/main.swift -o build/wandertest
./build/wandertest

echo
echo "== liveliness =="
swiftc -O $APPKIT $CORE $CONTENT $ENGINE app/Sources/Product.swift tools/alivetest/main.swift -o build/alivetest
./build/alivetest

echo
echo "== lip-sync registration =="
swiftc -O -framework AppKit $CORE app/Sources/Animator.swift \
  tools/talktest/main.swift -o build/talktest
for who in $CAST; do echo "-- $who"; ./build/talktest "$who"; done

# Speech and singing render real audio. That works headlessly, but a CI runner
# with no audio device at all is a different matter, so it can opt out.
if [ "${SKIP_AUDIO:-0}" = "1" ]; then
  echo
  echo "== voice and singing: skipped (SKIP_AUDIO=1) =="
  echo
  echo "== headless renders =="
  swiftc -O -framework AppKit $CORE tools/render/main.swift -o build/render
  for who in $CAST; do ./build/render "$APP" "$who" >/dev/null; done
  echo "sheets in shots/"
  exit 0
fi

echo
echo "== voice, visemes and icons =="
swiftc -O -framework AppKit -framework AVFoundation \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Voice.swift \
  app/Sources/Product.swift tools/voicetest/main.swift -o build/voicetest
for who in $CAST; do echo "-- $who"; ./build/voicetest "$who"; done

echo
echo "== repertoire and singing =="
swiftc -O -framework AppKit -framework AVFoundation \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Product.swift app/Sources/Voice.swift \
  tools/songtest/main.swift -o build/songtest
for who in $CAST; do
  for lang in en ar; do echo "-- $who/$lang"; ./build/songtest "$who" "$lang"; done
done

echo
echo "== Arabic reads cleanly =="
swiftc -O -framework AVFoundation -framework AppKit \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Product.swift app/Sources/Voice.swift \
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
for who in $CAST; do ./build/render "$APP" "$who" >/dev/null; done
swiftc -O -framework AppKit -framework AVFoundation \
  app/Sources/SpriteStore.swift $CONTENT app/Sources/Product.swift app/Sources/Voice.swift \
  app/Sources/BuddyView.swift tools/lipsync/main.swift -o build/lipsync
./build/lipsync
echo "sheets in shots/"
