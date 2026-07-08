#!/usr/bin/env bash
# need to install interception-tools first
set -euo pipefail

SRC="/tmp/claude-1000/-home-jacob/d00b0ca4-e3f0-4872-ac40-9c4bb2eb89d2/scratchpad/scroll-threshold.py"

echo ">> installing filter to /usr/local/bin/scroll-threshold"
install -m 0755 "$SRC" /usr/local/bin/scroll-threshold

echo ">> writing /etc/interception/udevmon.yaml"
mkdir -p /etc/interception
cat > /etc/interception/udevmon.yaml <<'YAML'
- JOB: "interception -g $DEVNODE | /usr/local/bin/scroll-threshold | uinput -d $DEVNODE"
  DEVICE:
    NAME: Logitech M705
YAML

echo ">> enabling + (re)starting udevmon.service"
systemctl daemon-reload
systemctl enable udevmon.service
systemctl restart udevmon.service
sleep 1

echo
echo ">> service status:"
systemctl --no-pager --full status udevmon.service | head -12 || true

echo
echo ">> M705 devices now present (expect the real one + a virtual clone):"
grep -B1 -A1 "Logitech M705" /proc/bus/input/devices | grep -E "N: Name|H: Handlers" || true
