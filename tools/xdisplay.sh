#!/usr/bin/env bash
# Kalıcı sanal ekranı (:99, 1920x1080) gerekirse başlatır. Tekrar çağrılması zararsızdır.
set -euo pipefail
if ! xdpyinfo -display :99 >/dev/null 2>&1 && ! pgrep -f "Xvfb :99" >/dev/null; then
  nohup Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp >/tmp/xvfb-99.log 2>&1 &
  for _ in $(seq 1 50); do [ -e /tmp/.X11-unix/X99 ] && break; sleep 0.1; done
fi
echo ":99"
