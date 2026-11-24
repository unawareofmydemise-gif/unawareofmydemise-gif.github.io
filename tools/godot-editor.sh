#!/usr/bin/env bash
# Godot editörünü sanal ekranda (Xvfb :99) arka planda çalıştırır ve Godot AI MCP köprüsünü hazırlar.
# Araçlar .mcp.json'daki "godot-ai" girdisiyle ya da tools/mcp-call.sh ile kullanılır.
#
# Kullanım:
#   tools/godot-editor.sh start [proje]   sunucuyu + editörü başlat (varsayılan proje: game); bağlantı kurulunca döner
#   tools/godot-editor.sh wait [sn]       editör hazır olana kadar bekle (varsayılan 1200 sn)
#   tools/godot-editor.sh status          durum + editor_state
#   tools/godot-editor.sh stop            editörü ve (bizim başlattığımız) sunucuyu kapat; iş bitince MUTLAKA
#   tools/godot-editor.sh log [satır]     editör günlüğünün sonu
#
# Tasarım: MCP sunucusunu (sabit sürüm, /opt/uomd-tools/godot-ai-venv) BİZ başlatırız, editör eklentisi onu devralır
# ("harici sunucu", eklentinin belgeli yolu). Eklentinin kendi uvx başlatması eşzamanlı başlatma yarışına açıktır
# ("server start blocked ... identity_mismatch": 4.4.2'de gözlendi) ve her açılışta ağ ister. Sunucu zaten çalışıyorsa
# (örn. oturumun .mcp.json köprüsü açtıysa) ona dokunmadan devralınır ve kapatılmaz.
#
# Bilmen gerekenler:
# - Telemetri kapalı (ortam değişkeni + editör ayarı); Godot'un kendi güncelleme denetimi de kapalı.
# - Mobile yöntemi zorlanır; editörden çalışan oyun da Mobile ile açılır (hedef platform).
# - Taze projede ilk açılışta editör tüm betikler için belge üretir ("readiness: importing"); yazılımsal render ve tek
#   iş parçacığı yüzünden dakikalar sürebilir. Sonraki açılışlar önbellekle daha hızlıdır.
# - Araçlar diske yazar (project_run varsayılanı sahneyi kaydeder: autosave=false ver). İş bitince `git status` bak.
set -euo pipefail
source "$(dirname "$(readlink -f "$0")")/env.sh"
STATE="$UOMD_ROOT/out/godot-editor"
PID_FILE="$STATE/editor.pid"
SERVER_PID_FILE="$STATE/server.pid"
LOG="$STATE/editor.log"
SERVER_LOG="$STATE/server.log"
TOOLS_DIR="${UOMD_TOOLS_DIR:-/opt/uomd-tools}"
GAI_VENV="$TOOLS_DIR/godot-ai-venv"
HTTP_PORT=8000
WS_PORT=9500
mkdir -p "$STATE"

pid_alive() { [ -f "$1" ] && kill -0 "$(cat "$1")" 2>/dev/null; }
alive() { pid_alive "$PID_FILE"; }
port_open() { (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null; }
editor_state() { "$UOMD_ROOT/tools/mcp-call.sh" godot-ai editor_state '{}' 2>/dev/null | grep -E '^\{' | head -1 || true; }
blocked() { grep -m1 -E "server start blocked|Failed to (start|launch)" "$LOG" 2>/dev/null | cut -c1-300 || true; }

prepare_settings() { # telemetri ve Godot'un kendi güncelleme denetimi kapalı (tekrar çağrılabilir)
  python3 -I - <<'PY'
import pathlib
import re

path = pathlib.Path.home() / ".config/godot/editor_settings-4.7.tres"
path.parent.mkdir(parents=True, exist_ok=True)
text = path.read_text() if path.exists() else '[gd_resource type="EditorSettings" format=3]\n\n[resource]\n'
for key, value in (("godot_ai/telemetry_enabled", "false"), ("network/connection/check_for_updates", "0")):
    if re.search(rf"^{re.escape(key)} = ", text, re.M):
        text = re.sub(rf"^{re.escape(key)} = .*$", f"{key} = {value}", text, flags=re.M)
    else:
        text = text.replace("[resource]\n", f"[resource]\n{key} = {value}\n", 1)
path.write_text(text)
PY
}

start_server() {
  if port_open $HTTP_PORT && port_open $WS_PORT; then
    echo "Godot AI sunucusu zaten çalışıyor (http $HTTP_PORT, ws $WS_PORT); devralınacak, kapatılmayacak"
    return 0
  fi
  if port_open $HTTP_PORT || port_open $WS_PORT; then
    echo "port $HTTP_PORT/$WS_PORT'den biri dolu ama diğeri boş: başka bir süreç çakışıyor" >&2
    exit 1
  fi
  [ -x "$GAI_VENV/bin/godot-ai" ] || { echo "godot-ai kurulu değil: bash tools/bootstrap.sh" >&2; exit 1; }
  GODOT_AI_DISABLE_TELEMETRY=true DISABLE_TELEMETRY=true nohup "$GAI_VENV/bin/godot-ai" --transport streamable-http \
    --port $HTTP_PORT --ws-port $WS_PORT --pid-file "$SERVER_PID_FILE" </dev/null >"$SERVER_LOG" 2>&1 &
  for _ in $(seq 1 60); do
    port_open $HTTP_PORT && port_open $WS_PORT && { echo "MCP sunucusu başlatıldı (http $HTTP_PORT, ws $WS_PORT)"; return 0; }
    sleep 1
  done
  echo "MCP sunucusu 60 sn içinde açılmadı; günlük: $SERVER_LOG" >&2
  tail -10 "$SERVER_LOG" >&2
  exit 1
}

start() {
  local project="${1:-$UOMD_ROOT/game}"
  [ -f "$project/project.godot" ] || { echo "proje yok: $project" >&2; exit 1; }
  if alive; then echo "editör zaten çalışıyor (PID $(cat "$PID_FILE"))"; return 0; fi
  prepare_settings
  start_server
  "$UOMD_ROOT/tools/xdisplay.sh" >/dev/null
  export DISPLAY=:99 GODOT_AI_DISABLE_TELEMETRY=true DISABLE_TELEMETRY=true
  cd "$project"
  nohup godot --editor --path "$project" --audio-driver Dummy --rendering-driver vulkan --rendering-method mobile \
    </dev/null >"$LOG" 2>&1 &
  echo $! >"$PID_FILE"
  echo "editör başlatıldı (PID $(cat "$PID_FILE")); eklentinin sunucuya bağlanması bekleniyor"
  for _ in $(seq 1 90); do
    alive || { echo "editör erken kapandı:" >&2; tail -15 "$LOG" >&2; exit 1; }
    if grep -q "authenticated with server" "$LOG" 2>/dev/null; then
      echo "eklenti sunucuya bağlandı. Editör hâlâ 'importing' olabilir: tools/godot-editor.sh wait"
      return 0
    fi
    if [ -n "$(blocked)" ]; then
      echo "eklenti engellendi: $(blocked)" >&2
      echo "çözüm: tools/godot-editor.sh stop && tools/godot-editor.sh start (sunucu önceden çalışırken genelde olmaz)" >&2
      exit 1
    fi
    sleep 2
  done
  echo "eklenti 180 sn içinde sunucuya bağlanmadı; günlük: $LOG" >&2
  exit 1
}

wait_ready() {
  local limit="${1:-1200}" begin state
  begin=$(date +%s)
  while [ $(($(date +%s) - begin)) -lt "$limit" ]; do
    alive || { echo "editör kapandı" >&2; tail -15 "$LOG" >&2; exit 1; }
    state=$(editor_state | grep -o '"readiness":"[a-z_]*"' || true)
    case "$state" in
      "" | *'"importing"'*) ;;
      *) echo "hazır ($(($(date +%s) - begin)) sn): $state"; return 0 ;;
    esac
    sleep 10
  done
  echo "zaman aşımı ($limit sn); son durum: ${state:-editör oturumu yok}" >&2
  return 1
}

stop() {
  if alive; then
    local pid
    pid=$(cat "$PID_FILE")
    kill "$pid" 2>/dev/null || true
    for _ in $(seq 1 30); do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    if kill -0 "$pid" 2>/dev/null; then kill -9 "$pid" 2>/dev/null || true; echo "editör zorla kapatıldı"; fi
  fi
  rm -f "$PID_FILE"
  if pid_alive "$SERVER_PID_FILE"; then # yalnız kendi başlattığımız sunucuyu kapat
    local spid
    spid=$(cat "$SERVER_PID_FILE")
    kill "$spid" 2>/dev/null || true
    for _ in $(seq 1 15); do kill -0 "$spid" 2>/dev/null || break; sleep 1; done
    kill -0 "$spid" 2>/dev/null && kill -9 "$spid" 2>/dev/null || true
  fi
  rm -f "$SERVER_PID_FILE"
  echo "editör kapalı; kendi başlattığımız MCP sunucusu kapalı"
}

case "${1:-}" in
  start) start "${2:-}" ;;
  wait) wait_ready "${2:-1200}" ;;
  status)
    if alive; then echo "editör çalışıyor (PID $(cat "$PID_FILE"))"; editor_state; else echo "editör kapalı"; fi
    if pid_alive "$SERVER_PID_FILE"; then echo "sunucu: bizim başlattığımız (PID $(cat "$SERVER_PID_FILE"))"
    elif port_open $HTTP_PORT; then echo "sunucu: dışarıdan başlatılmış (kapatılmaz)"; else echo "sunucu: kapalı"; fi
    ;;
  stop) stop ;;
  log) tail -n "${2:-40}" "$LOG" | cut -c1-240 ;;
  *) sed -n '2,20p' "$0"; exit 1 ;;
esac
