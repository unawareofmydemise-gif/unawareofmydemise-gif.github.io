#!/usr/bin/env bash
# MCP sunucusu oturuma yüklü değilken araçlarını Bash'ten çağırır (bkz. tools/mcp/call.py).
# Kullanım: tools/mcp-call.sh godot-ai --list | tools/mcp-call.sh godot-ai editor_state '{}'
set -euo pipefail
exec /opt/uomd-tools/venv/bin/python "$(dirname "$(readlink -f "$0")")/mcp/call.py" "$@"
