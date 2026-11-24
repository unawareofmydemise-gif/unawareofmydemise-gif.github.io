# art_src — 3D modellerin kaynağı

Her model bir Blender Python betiğidir. Betik modeli sıfırdan kurar; aynı betik her çalıştığında aynı modeli üretir.

```
art_src/
├── lib/                 ortak modüller (render, malzeme, gövde tabanı, saç, kıyafet yardımcıları)
├── characters/<id>/     build.py + notes.md (referanslar, kararlar, QA geçmişi)
├── environments/<id>/   mekân parçaları
└── props/<id>/          eşyalar ve silahlar
```

## Betik kalıbı

```python
# art_src/characters/<id>/build.py
import sys, os, bpy
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "lib"))
from uomd_render import render_views

args = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
bpy.ops.wm.read_factory_settings(use_empty=True)

def build():
    ...  # modeli kur

build()
if "--render" in args:
    render_views("out/characters/<id>", height=1.65)
if "--export" in args:
    bpy.ops.export_scene.gltf(filepath="game/assets/characters/<id>.glb")
```

Çalıştırma (repo kökünden):

```bash
tools/blender.sh art_src/characters/<id>/build.py -- --render
python3 tools/qa/sheet.py out/characters/<id>/sheet.png art/portraits/<id>/composed.webp out/characters/<id>/*.png
```
