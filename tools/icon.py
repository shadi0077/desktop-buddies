"""Build AppIcon.icns from a hero frame."""
from PIL import Image
import os, subprocess, shutil

HERO = 401          # wings up, reads well small
src = Image.open(f"assets/rgba/{HERO:04d}.png").convert("RGBA")
bb = src.getbbox()
bird = src.crop(bb)

iconset = "build/AppIcon.iconset"
shutil.rmtree(iconset, ignore_errors=True)
os.makedirs(iconset)

def render(px):
    # macOS icons want a little breathing room inside the square.
    pad = round(px * 0.08)
    box = px - 2 * pad
    scale = min(box / bird.width, box / bird.height)
    w, h = max(1, round(bird.width * scale)), max(1, round(bird.height * scale))
    canvas = Image.new("RGBA", (px, px), (0, 0, 0, 0))
    canvas.paste(bird.resize((w, h), Image.LANCZOS),
                 ((px - w) // 2, (px - h) // 2))
    return canvas

for size in (16, 32, 128, 256, 512):
    render(size).save(f"{iconset}/icon_{size}x{size}.png")
    render(size * 2).save(f"{iconset}/icon_{size}x{size}@2x.png")

subprocess.run(["iconutil", "-c", "icns", iconset, "-o", "app/Resources/AppIcon.icns"],
               check=True)
print("wrote app/Resources/AppIcon.icns",
      os.path.getsize("app/Resources/AppIcon.icns") // 1024, "KB")
