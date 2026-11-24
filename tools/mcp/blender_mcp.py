#!/usr/bin/env python3
"""UOMD Blender MCP köprüsü: Claude'un Blender'ı yönetmesi VE izlemesi için.

Arka planda süreç ya da açık port yok. Her araç çağrısı Blender'ı ekransız başlatır (tools/blender.sh),
kalıcı oturum dosyası (out/blender/session.blend) üzerinde çalışır ve kapanır.
Her adım out/blender/journal/ altına yazılır (journal.md + görüntüler): yapılan işler geriye dönük izlenebilir.
"""
import datetime
import json
import os
import shutil
import subprocess
import tempfile
from pathlib import Path

from mcp.server.mcpserver import MCPServer
from mcp.server.mcpserver.utilities.types import Image

REPO = Path(os.environ.get("UOMD_ROOT", Path(__file__).resolve().parents[2]))
WORK = Path(os.environ.get("UOMD_BLENDER_WORK", REPO / "out" / "blender"))
SESSION = WORK / "session.blend"
JOURNAL = WORK / "journal"
RUNNER = REPO / "tools" / "mcp" / "blender_runner.py"
TIMEOUT = int(os.environ.get("UOMD_BLENDER_TIMEOUT", "900"))

mcp = MCPServer("uomd-blender")


def _run(action: str, **params) -> dict:
    WORK.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        req = {"action": action, "session": str(SESSION), "repo": str(REPO), "result": f"{tmp}/result.json", **params}
        Path(f"{tmp}/req.json").write_text(json.dumps(req))
        proc = subprocess.run([str(REPO / "tools" / "blender.sh"), str(RUNNER), "--", f"{tmp}/req.json"],
                              capture_output=True, text=True, timeout=TIMEOUT, cwd=REPO)
        try:
            res = json.loads(Path(req["result"]).read_text())
        except FileNotFoundError:
            res = {"ok": False, "error": "Blender sonuç üretmeden kapandı.", "blender_log": proc.stdout[-6000:] + proc.stderr[-3000:]}
    return res


def _journal(tool: str, summary: str, images: list[str] | None = None) -> None:
    JOURNAL.mkdir(parents=True, exist_ok=True)
    n = len(list(JOURNAL.glob("*.md"))) + 1
    stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    lines = [f"## {n:04d} · {stamp} · {tool}", "", summary.strip(), ""]
    for img in images or []:
        dst = JOURNAL / f"{n:04d}_{Path(img).name}"
        shutil.copy(img, dst); lines.append(f"![{Path(img).stem}]({dst.name})")
    (JOURNAL / f"{n:04d}.md").write_text("\n".join(lines) + "\n")
    with open(JOURNAL / "journal.md", "a") as f:
        f.write("\n".join(lines) + "\n\n")


def _summ(res: dict) -> str:
    info = res.get("info") or {}
    head = "OK" if res.get("ok") else "HATA"
    parts = [f"{head} · {info.get('object_count', 0)} nesne · {info.get('total_verts', 0)} nokta · sınırlar {info.get('bounds')}"]
    if res.get("stdout"):
        parts.append("stdout:\n" + res["stdout"][-4000:])
    if res.get("error"):
        parts.append("hata:\n" + res["error"])
    if res.get("blender_log"):
        parts.append("blender kaydı:\n" + res["blender_log"])
    return "\n".join(parts)


@mcp.tool()
def blender_reset() -> str:
    """Oturumu boş bir sahneyle sıfırlar (out/blender/session.blend)."""
    res = _run("reset"); _journal("reset", _summ(res)); return _summ(res)


@mcp.tool()
def blender_execute(code: str, save: bool = True) -> str:
    """Oturum sahnesinde Python (bpy) kodu çalıştırır; stdout, hata ve sahne özetini döndürür.
    save=True ise başarılı çalışmadan sonra oturum kaydedilir. Sonucu görmek için blender_screenshot çağır."""
    res = _run("execute", code=code, save=save)
    _journal("execute", "```python\n" + code[:3000] + "\n```\n\n" + _summ(res)); return _summ(res)


@mcp.tool()
def blender_run_script(path: str, args: list[str] | None = None) -> str:
    """Repo içindeki bir Blender betiğini (örn. art_src/characters/<id>/build.py) oturumda çalıştırır ve kaydeder."""
    full = (REPO / path).resolve()
    if not str(full).startswith(str(REPO)) or not full.exists():
        return f"HATA: betik bulunamadı ya da repo dışında: {path}"
    res = _run("script", path=str(full), args=args or [])
    _journal("run_script", f"`{path}` {args or ''}\n\n" + _summ(res)); return _summ(res)


@mcp.tool()
def blender_scene_info() -> str:
    """Oturum sahnesindeki nesneleri döndürür: tür, konum, boyut, nokta/yüz sayısı, malzeme, değiştirici,
    şekil anahtarı, iskelet kemikleri ve genel sınırlar (JSON)."""
    return json.dumps(_run("info").get("info"), ensure_ascii=False, indent=1)


@mcp.tool()
def blender_screenshot(views: list[str] | None = None, reference: str | None = None, toon: bool = False) -> list:
    """Sahneyi standart açılardan render eder ve görüntüleri döndürür (izleme için).
    Varsayılan hızlı önizleme (Workbench, düz gölge); toon=True ise EEVEE (malzemeler/toon, çok daha yavaş).
    views: front, three_quarter, side, back (varsayılan hepsi). reference: repo içi referans görsel yolu
    (örn. art/portraits/fadyme/composed.webp) verilirse karşılaştırma sayfası da üretilir."""
    stamp = datetime.datetime.now().strftime("%H%M%S")
    out_dir = WORK / "shots" / stamp
    res = _run("render", out_dir=str(out_dir), views=views or ["front", "three_quarter", "side", "back"],
               engine="BLENDER_EEVEE" if toon else "BLENDER_WORKBENCH")
    if not res.get("ok"):
        return [_summ(res)]
    paths = res["paths"]
    sheet = out_dir / "sheet.png"
    cmd = ["python3", str(REPO / "tools" / "qa" / "sheet.py"), str(sheet)]
    cmd += [str(REPO / reference)] if reference else []
    subprocess.run(cmd + paths + ["--height", "720"], check=True, capture_output=True)
    _journal("screenshot", f"açılar: {views or 'hepsi'} · toon: {toon} · referans: {reference}", [str(sheet)])
    return [Image(path=str(sheet)), f"Sayfa: {sheet}\nTek tek: {', '.join(paths)}\n" + _summ(res)]


@mcp.tool()
def blender_export_glb(path: str) -> str:
    """Oturum sahnesini glTF (.glb) olarak dışa aktarır; yol repo köküne göredir (örn. game/assets/characters/x.glb)."""
    full = (REPO / path).resolve()
    if not str(full).startswith(str(REPO)):
        return "HATA: yol repo dışında"
    res = _run("export", path=str(full))
    _journal("export_glb", f"`{path}`\n\n" + _summ(res)); return _summ(res) + f"\n→ {path}"


@mcp.tool()
def blender_journal(last: int = 10) -> str:
    """Son N adımın günlüğünü döndürür (ne yapıldı, ne zaman, sonuç). Görüntüler out/blender/journal/ altında."""
    files = sorted(JOURNAL.glob("[0-9]*.md"))[-last:] if JOURNAL.exists() else []
    return "\n".join(f.read_text() for f in files) or "Günlük boş."


if __name__ == "__main__":
    mcp.run()
