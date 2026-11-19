#!/usr/bin/env bash
# photos-src/ 의 원본을 청첩장에 쓸 크기로 줄여 docs/photos/ 에 만든다.
# 원본을 바꾸거나 더 넣었으면 ./make-photos.sh 로 다시 돌린 뒤 ./build.sh && git push.
set -euo pipefail
cd "$(dirname "$0")"
[ -x .venv/bin/python3 ] || { echo "먼저: python3 -m venv .venv && ./.venv/bin/pip install pillow"; exit 1; }

./.venv/bin/python3 - <<'PY'
import os, glob
from PIL import Image, ImageOps

SRC, OUT = "photos-src", "docs/photos"
os.makedirs(OUT, exist_ok=True)

def save(src_name, out_name, ratio, width):
    """ratio = 가로/세로. 가운데를 기준으로 잘라 width 폭으로 저장."""
    path = os.path.join(SRC, src_name)
    if not os.path.exists(path):
        print(f"  건너뜀 (원본 없음): {src_name}")
        return
    im = ImageOps.exif_transpose(Image.open(path)).convert("RGB")
    im = ImageOps.fit(im, (width, round(width / ratio)), method=Image.LANCZOS, centering=(0.5, 0.5))
    dst = os.path.join(OUT, out_name)
    im.save(dst, "JPEG", quality=82, optimize=True, progressive=True)
    print(f"  {out_name:10s} {im.width}x{im.height:5d}  {os.path.getsize(dst)/1024:6.0f} KB")

print("표지 (3:4)")
save("cover.JPG", "cover.jpg", 3/4, 1200)

print("갤러리 (2:3, 원본 비율 그대로)")
n = 0
for p in sorted(glob.glob(os.path.join(SRC, "[0-9][0-9].JPG"))):
    base = os.path.basename(p)
    save(base, base.lower(), 2/3, 900)
    n += 1

total = sum(os.path.getsize(os.path.join(OUT, f)) for f in os.listdir(OUT) if f.endswith(".jpg"))
print(f"\n갤러리 {n}장 · 전체 {total/1024/1024:.1f} MB")
PY
