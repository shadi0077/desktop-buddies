#!/bin/bash
# Builds Peedy.app. No Xcode project needed - just the Swift toolchain.
set -euo pipefail
cd "$(dirname "$0")"

APP="build/Peedy.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc -O \
  -target arm64-apple-macos11.0 \
  -framework AppKit -framework ServiceManagement -framework AVFoundation \
  app/Sources/*.swift \
  -o "$APP/Contents/MacOS/Peedy"

cp app/Info.plist "$APP/Contents/Info.plist"
cp -R app/Resources/characters "$APP/Contents/Resources/characters"
[ -f app/Resources/AppIcon.icns ] && cp app/Resources/AppIcon.icns "$APP/Contents/Resources/"

# Ad-hoc sign so macOS is happy to run it locally.
codesign --force --deep --sign - "$APP" >/dev/null 2>&1 || \
  echo "note: ad-hoc codesign skipped"

echo "built $APP"
