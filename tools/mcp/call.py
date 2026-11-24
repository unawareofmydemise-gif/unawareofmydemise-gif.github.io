#!/usr/bin/env python3
"""Bir MCP sunucusunu .mcp.json'daki tanımıyla başlatıp araç çağırır.

Sunucu Claude oturumuna yüklü değilse (MCP yalnız oturum başında yüklenir) aynı araçlar buradan kullanılır.
Kullanım (tools/mcp-call.sh sarmalayıcısı doğru Python'u seçer):
  tools/mcp-call.sh <sunucu> --list                          araçları listele (ad + ilk satır açıklama)
  tools/mcp-call.sh <sunucu> --schema <araç>                 aracın tam açıklaması ve parametre şeması
  tools/mcp-call.sh <sunucu> <araç> '<json argümanlar>'      tek çağrı
  tools/mcp-call.sh <sunucu> --batch calls.json              [{"tool": "...", "args": {...}}, ...] tek oturumda sırayla
Görüntüler out/mcp/ altına PNG olarak kaydedilir ve yolu yazılır. Çıkış kodu: araç hata verirse 1. (mcp 2.x alan adları snake_case: is_error, structured_content.)
"""
import argparse
import asyncio
import base64
import json
import os
import sys
import time
from pathlib import Path

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

REPO = Path(__file__).resolve().parents[2]
OUT = REPO / "out" / "mcp"


def server_params(name: str) -> StdioServerParameters:
    servers = json.loads((REPO / ".mcp.json").read_text())["mcpServers"]
    if name not in servers:
        sys.exit(f"'{name}' .mcp.json'da yok. Var olanlar: {', '.join(servers)}")
    cfg = servers[name]
    env = {"PATH": os.environ.get("PATH", ""), "HOME": os.environ.get("HOME", "/root"), **cfg.get("env", {})}
    return StdioServerParameters(command=cfg["command"], args=cfg.get("args", []), env=env)


def show(result, label: str) -> bool:
    """Sonucu yazdırır, görüntüleri kaydeder; hata yoksa True döndürür."""
    OUT.mkdir(parents=True, exist_ok=True)
    for i, part in enumerate(result.content):
        if part.type == "text":
            print(part.text)
        elif part.type == "image":
            path = OUT / f"{label}-{int(time.time())}-{i}.png"
            path.write_bytes(base64.b64decode(part.data))
            print(f"[görüntü] {path}")
        else:
            print(f"[{part.type}]")
    if result.structured_content and not any(p.type == "text" for p in result.content):
        print(json.dumps(result.structured_content, ensure_ascii=False, indent=1))
    return not result.is_error


async def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("server")
    ap.add_argument("tool", nargs="?")
    ap.add_argument("args", nargs="?", default="{}")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--schema")
    ap.add_argument("--batch")
    a = ap.parse_args()
    ok = True
    async with stdio_client(server_params(a.server)) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            if a.list:
                for tool in (await session.list_tools()).tools:
                    print(f"{tool.name}\t{(tool.description or '').strip().splitlines()[0][:110] if tool.description else ''}")
            elif a.schema:
                for tool in (await session.list_tools()).tools:
                    if tool.name == a.schema:
                        print(tool.description)
                        props = (tool.input_schema or {}).get("properties", {})
                        required = (tool.input_schema or {}).get("required", [])
                        print("\nPARAMETRELER:")
                        for key, spec in props.items():
                            kind = spec.get("type") or "/".join(x.get("type", "?") for x in spec.get("anyOf", []))
                            note = (spec.get("description") or "").replace("\n", " ")[:160]
                            mark = " (zorunlu)" if key in required else ""
                            print(f"  {key}: {kind}{mark} varsayılan={spec.get('default')!r} {note}")
            elif a.batch:
                for n, call in enumerate(json.loads(Path(a.batch).read_text())):
                    print(f"--- [{n}] {call['tool']}")
                    ok &= show(await session.call_tool(call["tool"], call.get("args", {})), f"{a.server}-{call['tool']}")
            elif a.tool:
                ok = show(await session.call_tool(a.tool, json.loads(a.args)), f"{a.server}-{a.tool}")
            else:
                ap.error("araç adı, --list ya da --batch ver")
    return 0 if ok else 1


sys.exit(asyncio.run(main()))
