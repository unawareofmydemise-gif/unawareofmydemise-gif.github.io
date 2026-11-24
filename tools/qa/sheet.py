#!/usr/bin/env python3
"""Karşılaştırma sayfası: referans çizim(ler) + render'ları tek görüntüde yan yana koyar.

Kullanım: python3 tools/qa/sheet.py çıktı.png ref.png render1.png render2.png ... [--height 900]
Her görsel aynı yüksekliğe ölçeklenir, altına dosya adı yazılır.
"""
import argparse
import os
from PIL import Image, ImageDraw

ap = argparse.ArgumentParser()
ap.add_argument("out"); ap.add_argument("images", nargs="+")
ap.add_argument("--height", type=int, default=900)
a = ap.parse_args()
tiles = []
for p in a.images:
    im = Image.open(p).convert("RGBA")
    w = round(im.width * a.height / im.height)
    bg = Image.new("RGBA", (w, a.height), (60, 60, 60, 255))
    bg.alpha_composite(im.resize((w, a.height)))
    tiles.append((bg.convert("RGB"), os.path.basename(p)))
label_h = 34
sheet = Image.new("RGB", (sum(t.width for t, _ in tiles) + 10 * (len(tiles) - 1), a.height + label_h), (25, 25, 25))
x = 0; d = ImageDraw.Draw(sheet)
for im, name in tiles:
    sheet.paste(im, (x, 0)); d.text((x + 8, a.height + 9), name, fill=(230, 230, 230)); x += im.width + 10
sheet.save(a.out); print(a.out)
