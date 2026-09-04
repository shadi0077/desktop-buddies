"""Render a product's cast as one lineup image, for the docs.

Usage: lineup.py <product-id> [clip] [out.png]

One frame per character, bottom-aligned on a shared baseline so the
size differences between them are the real ones, with names underneath.
"""
from PIL import Image, ImageDraw, ImageFont
import json, sys
from pathlib import Path

pid = sys.argv[1]
clip = sys.argv[2] if len(sys.argv) > 2 else "rest"
out = Path(sys.argv[3] if len(sys.argv) > 3 else f"docs/img/{pid}.png")

manifest = json.load(open(f"products/{pid}.json"))
cast = [c for c in manifest["cast"] if not c.startswith("_")]

SCALE, PAD, GAP, LABEL = 2, 18, 14, 22
FONT = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", 15)

art = []
for who in cast:
    root = Path("app/Resources/characters") / who
    anims = json.load(open(root / "animations.json"))["animations"]
    steps = (anims.get(clip) or anims["rest"])["steps"]
    # Mid-clip: the extremes of a walk cycle are the least representative frame.
    frame = steps[len(steps) // 2]["f"]
    img = Image.open(root / "frames" / f"{frame:04d}.png").convert("RGBA")
    img = img.crop(img.getbbox())
    img = img.resize((img.width * SCALE, img.height * SCALE), Image.LANCZOS)
    art.append((who, img))

width = PAD * 2 + sum(i.width for _, i in art) + GAP * (len(art) - 1)
tall = max(i.height for _, i in art)
sheet = Image.new("RGBA", (width, PAD * 2 + tall + LABEL), (0, 0, 0, 0))
draw = ImageDraw.Draw(sheet)

x = PAD
for who, img in art:
    sheet.alpha_composite(img, (x, PAD + tall - img.height))
    draw.text((x + img.width / 2, PAD + tall + 6), who.capitalize(),
              font=FONT, fill=(122, 122, 128, 255), anchor="ma")
    x += img.width + GAP

out.parent.mkdir(parents=True, exist_ok=True)
sheet.save(out)
print(f"{out}  {sheet.width}x{sheet.height}  {len(art)} characters")
