#!/usr/bin/env python3
"""Godot AI canlı duman testi: çalışan editöre .mcp.json'daki "godot-ai" girdisiyle bağlanır.

Sahneyi açar, hiyerarşiyi okur, oyunu editörden çalıştırır, oyun karesini yakalar (boş mu?), günlükleri okur, durdurur.
Editörün açık ve hazır olması gerekir; yaşam döngüsünü tools/smoke/godot_ai_live.sh yönetir.
Kullanım: /opt/uomd-tools/venv/bin/python tools/smoke/godot_ai_smoke.py <çıktı_klasörü>
"""
import asyncio
import base64
import json
import os
import sys
from pathlib import Path

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

REPO = Path(__file__).resolve().parents[2]
out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
cfg = json.loads((REPO / ".mcp.json").read_text())["mcpServers"]["godot-ai"]
ok = True


def check(label, cond, detail=""):
    global ok
    print(("SMOKE_GAI_OK " if cond else "SMOKE_GAI_FAIL ") + label + (f" ({detail})" if detail else ""))
    ok &= bool(cond)


def text(res):
    return "".join(c.text for c in res.content if c.type == "text")


async def main():
    env = {"PATH": os.environ["PATH"], "HOME": os.environ.get("HOME", "/root"), **cfg.get("env", {})}
    params = StdioServerParameters(command=cfg["command"], args=cfg.get("args", []), env=env)
    async with stdio_client(params) as (read, write):
        async with ClientSession(read, write) as s:
            await s.initialize()
            tools = {t.name for t in (await s.list_tools()).tools}
            check("araç yüzeyi (>= 40 araç)", len(tools) >= 40 and {"editor_state", "scene_open", "project_run"} <= tools, str(len(tools)))
            state = json.loads(text(await s.call_tool("editor_state", {})))
            check("editör 4.7 ve proje adı", state["godot_version"].startswith("4.7") and state["project_name"], state["godot_version"])
            res = await s.call_tool("scene_open", {"path": "res://scenes/dev/toon_stage.tscn"})
            check("scene_open", '"switched":true' in text(res), text(res)[:100])
            tree = text(await s.call_tool("scene_get_hierarchy", {"depth": 2, "limit": 10}))
            check("scene_get_hierarchy", "ToonStage" in tree)
            res = await s.call_tool("project_run", {"mode": "current", "autosave": False})
            check("project_run: oyun yardımcısı canlı", '"helper_live":true' in text(res), text(res)[:100])
            shot = await s.call_tool("editor_screenshot", {"source": "game", "max_resolution": 1280})
            images = [c for c in shot.content if c.type == "image"]
            check("oyun karesi yakalandı", len(images) == 1)
            if images:
                data = base64.b64decode(images[0].data)
                (out / "godot_ai_game.png").write_bytes(data)
                check("oyun karesi boş değil", len(data) > 20_000, f"{len(data)} bayt")
            logs = text(await s.call_tool("logs_read", {"source": "game", "count": 20}))
            check("oyun günlüğü okundu", "game_helper" in logs)
            res = await s.call_tool("project_manage", {"op": "stop"})
            check("project_manage stop", '"stopped":true' in text(res))


asyncio.run(main())
sys.exit(0 if ok else 1)
