#!/bin/bash
# Rebuild a character's asset pack from the source artwork.
#
# The packed sprites are committed, so a clone builds and runs both apps
# without any of this. You need it only to add a character, to redo one from a
# different rip, or to change the pipeline itself.
#
# The two apps' artwork arrives in two entirely different shapes, so there are
# two pipelines:
#
#   ./setup.sh agent <peedy.zip> [bonzi.zip]        Microsoft Agent dumps
#   ./setup.sh sheet <name> <sheet.png> [key] [y0:y1]   game sprite sheets
#
set -euo pipefail
cd "$(dirname "$0")"

usage() {
    cat <<'USAGE'
usage: ./setup.sh agent <peedy-sprites.zip> [bonzi-sprites.zip]
       ./setup.sh sheet <name> <sheet.png> [key_r,key_g,key_b | alpha] [y0:y1]

agent — Desktop Buddies. Each zip holds numbered PNG frames on a flat
        colour-key background: the "BonziBUDDY - Characters - Peedy" and
        "- Bonzi" dumps. The key is read off the art, so cyan, magenta and
        green dumps all work. Peedy alone is enough to run the app.

        The other seven characters arrive as one gridded sheet rather than
        numbered files; those go through tools/grid.py first — see
        docs/SPRITES.md.

sheet — MegaDrive Buddies. A spriters-resource style sheet with frames laid
        out in rows.

          name   what the character will be called, e.g. "shiva"
          key    background colour to knock out, "r,g,b" (default 204,255,204).
                 Pass "alpha" if the sheet is already transparent; it is
                 auto-detected either way.
          y0:y1  optional horizontal slice, for sheets holding several
                 characters

Either way, author the clip ranges in tools/catalog.py afterwards and add a
Personality — see CONTRIBUTING.md.
USAGE
    exit 1
}

need() { command -v "$1" >/dev/null 2>&1 || { echo "error: $1 is required"; exit 1; }; }

pillow() {
    python3 -c "import PIL" 2>/dev/null || {
        echo "==> installing Pillow (image tooling)"
        python3 -m pip install --quiet --user pillow
    }
}

do_agent() {
    [ $# -ge 1 ] || usage
    need python3; need unzip; need swiftc; pillow

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

        echo "==> $name: keying out the background"
        python3 tools/extract.py "$name"
        echo "==> $name: trimming and packing"
        python3 tools/pack.py "$name"
    }

    unpack peedy "$1"
    [ $# -ge 2 ] && unpack bonzi "$2"

    echo "==> measuring visemes and writing the animation catalogue"
    python3 tools/catalog.py

    echo "==> building"
    ./build.sh desktop-buddies

    cat <<'DONE'

Done. Run it with:

    open "build/Desktop Buddies.app"

DONE
}

do_sheet() {
    [ $# -ge 2 ] || usage
    need python3; need swiftc; pillow

    echo "==> cutting the sheet"
    python3 tools/sheet.py "$@"

    echo "==> rendering the numbered index"
    python3 tools/index.py "$1"

    cat <<DONE

Frames are in app/Resources/characters/$1/.
Open tools/out/$1-index.png, note which frames belong to which animation,
then add the ranges to tools/catalog.py and a Personality in app/Sources/.

DONE
}

[ $# -ge 1 ] || usage
case "$1" in
    agent) shift; do_agent "$@" ;;
    sheet) shift; do_sheet "$@" ;;
    # The old form took the Agent zips directly, before there were two apps.
    *.zip) do_agent "$@" ;;
    *)     usage ;;
esac
