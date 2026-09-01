"""Cut a spriters-resource style sheet into frames.

The Microsoft Agent characters arrived as numbered files, one frame each. Game
rips arrive as a single sheet with frames laid out in irregular rows, so they
need segmenting: find bands of content, then columns within each band.

Usage: sheet.py <character> <sheet.png> [key_r,key_g,key_b]

Caveat worth knowing before authoring animations: a caption printed directly
above a sprite ends up inside that frame, because the band containing both is
one run of content. Those frames look normal by size, so they can't be filtered
out automatically — render the numbered index and look. Blaze's walk cycle
starts two frames later than it appears to for exactly this reason.
"""
from PIL import Image
import json, os, shutil, sys

name = sys.argv[1]
src = sys.argv[2]
key = tuple(int(v) for v in (sys.argv[3].split(",") if len(sys.argv) > 3
                             else "204,255,204".split(",")))

im = Image.open(src).convert("RGBA")
W, H = im.size
px = im.load()

# Bands: horizontal runs that contain any non-key pixel.
bands = []
run = None
for y in range(H):
    filled = any(px[x, y][:3] != key for x in range(W))
    if filled and run is None:
        run = y
    elif not filled and run is not None:
        bands.append((run, y - 1))
        run = None
if run is not None:
    bands.append((run, H - 1))

# Frames: within a band, vertical runs of content, then trimmed to their own
# bounding box so a tall band doesn't pad every frame in it.
frames = []          # (band, x0, y0, x1, y1)
for b, (y0, y1) in enumerate(bands):
    cols, run = [], None
    for x in range(W):
        filled = any(px[x, y][:3] != key for y in range(y0, y1 + 1))
        if filled and run is None:
            run = x
        elif not filled and run is not None:
            if x - run > 3:
                cols.append((run, x - 1))
            run = None
    if run is not None and W - run > 3:
        cols.append((run, W - 1))

    for (x0, x1) in cols:
        ys = [y for y in range(y0, y1 + 1)
              if any(px[x, y][:3] != key for x in range(x0, x1 + 1))]
        if not ys:
            continue
        top, bottom = min(ys), max(ys)
        if (x1 - x0 + 1) < 8 or (bottom - top + 1) < 8:
            continue          # ruler marks and stray pixels, not frames
        frames.append((b, x0, top, x1, bottom))

# One canvas for everyone, anchored bottom-centre so his feet stay planted.
cw = max(f[3] - f[1] + 1 for f in frames) + 8
ch = max(f[4] - f[2] + 1 for f in frames) + 8

out = f"app/Resources/characters/{name}"
if os.path.isdir(f"{out}/frames"):
    shutil.rmtree(f"{out}/frames")
os.makedirs(f"{out}/frames", exist_ok=True)

manifest, index = [], []
for i, (b, x0, y0, x1, y1) in enumerate(frames):
    w, h = x1 - x0 + 1, y1 - y0 + 1
    crop = im.crop((x0, y0, x1 + 1, y1 + 1))
    cp = crop.load()
    for y in range(h):
        for x in range(w):
            if cp[x, y][:3] == key:
                cp[x, y] = (0, 0, 0, 0)
    crop.save(f"{out}/frames/{i:04d}.png", optimize=True)
    manifest.append(dict(x=(cw - w) // 2, y=ch - h - 4, w=w, h=h))
    index.append(dict(i=i, band=b, w=w, h=h))

json.dump(dict(canvas=dict(w=cw, h=ch), frames=manifest),
          open(f"{out}/frames.json", "w"))
os.makedirs("tools/out", exist_ok=True)
json.dump(dict(bands=len(bands), frames=index), open(f"tools/out/{name}-sheet.json", "w"))

total = sum(os.path.getsize(f"{out}/frames/{f}") for f in os.listdir(f"{out}/frames"))
print(f"{name}: {len(frames)} frames from {len(bands)} bands, "
      f"canvas {cw}x{ch}, {total/1024:.0f} KB")
for b in range(len(bands)):
    n = sum(1 for f in index if f["band"] == b)
    if n:
        print(f"   band {b:2d}: frames {min(f['i'] for f in index if f['band']==b)}"
              f"-{max(f['i'] for f in index if f['band']==b)}  ({n})")
