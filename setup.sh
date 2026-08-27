#!/bin/bash
# Build the character asset pack from your own copies of the sprite dumps.
#
# The sprites aren't redistributed with this project (see docs/SPRITES.md), so
# this is the one step you have to do yourself. It takes a couple of minutes and
# only needs doing once.
#
#   ./setup.sh <peedy.zip> <bonzi.zip>
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -lt 1 ]; then
    cat <<'USAGE'
usage: ./setup.sh <peedy-sprites.zip> [bonzi-sprites.zip]

Each zip should contain numbered PNG frames on a cyan (#00FFFF) background —
the "BonziBUDDY - Characters - Peedy" and "- Bonzi" dumps.

Peedy alone is enough to run the app; Bonzi is optional.
USAGE
    exit 1
fi

need() {
    command -v "$1" >/dev/null 2>&1 || { echo "error: $1 is required"; exit 1; }
}
need python3
need unzip
need swiftc

python3 -c "import PIL" 2>/dev/null || {
    echo "==> installing Pillow (image tooling)"
    python3 -m pip install --quiet --user pillow
}

unpack() {
    local name="$1" zip="$2"
    [ -f "$zip" ] || { echo "error: no such file: $zip"; exit 1; }
    echo "==> $name: unpacking"
    rm -rf "assets/$name"
    mkdir -p "assets/$name"
    unzip -q -j "$zip" '*.png' -d "assets/$name/frames"
    # Some dumps carry a palette swatch alongside the frames; it isn't a frame.
    rm -f "assets/$name/frames/colortable.png"
    local count
    count=$(find "assets/$name/frames" -name '*.png' | wc -l | tr -d ' ')
    [ "$count" -gt 100 ] || { echo "error: only $count frames found in $zip"; exit 1; }
    echo "    $count frames"

    echo "==> $name: keying out the cyan background"
    python3 tools/extract.py "$name"
    echo "==> $name: trimming and packing"
    python3 tools/pack.py "$name"
}

unpack peedy "$1"
[ $# -ge 2 ] && unpack bonzi "$2"

echo "==> measuring visemes and writing the animation catalogue"
python3 tools/catalog.py

echo "==> building"
./build.sh

cat <<'DONE'

Done. Run it with:

    open build/Peedy.app

DONE
