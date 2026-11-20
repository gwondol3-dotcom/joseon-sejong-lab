"""그림 마무리: 아이콘 초록 배경 지우기 + 모든 그림을 webp로 바꾸기."""
import subprocess, sys
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parent.parent
assets = root / 'assets'
chroma = root.parents[2] / '.claude' / 'skills' / 'codex-image' / 'scripts' / 'remove_chroma.py'

for raw in sorted(assets.glob('*-raw.png')):
    out = assets / raw.name.replace('-raw', '')
    if not out.exists():
        subprocess.run([sys.executable, str(chroma), str(raw), str(out), '--size', '512', '--all'], check=True)

for png in sorted(assets.glob('*.png')):
    if png.name.endswith('-raw.png'):
        continue
    im = Image.open(png)
    if im.mode not in ('RGB', 'RGBA'):
        im = im.convert('RGBA')
    if max(im.size) > 1200:
        im.thumbnail((1200, 1200))
    im.save(png.with_suffix('.webp'), 'WEBP', quality=82, method=6)
    print('webp', png.stem)
