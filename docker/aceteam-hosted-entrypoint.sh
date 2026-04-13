#!/bin/sh
# AceTeam-hosted SafeClaw: writes ~/.openclaw/openclaw.json from the first
# argument (base64-encoded JSON from Railway startCommand), then execs the gateway.

set -eu

CONFIG_PATH="/home/node/.openclaw/openclaw.json"
log() {
  printf '%s\n' "$*" >&2
}

log "[aceteam-hosted-entrypoint] writing config to ${CONFIG_PATH}"
mkdir -p /home/node/.openclaw

b64="${1-}"
if [ -z "$b64" ]; then
  log "[aceteam-hosted-entrypoint] error: missing base64 JSON argument"
  exit 1
fi

printf '%s' "$b64" | base64 -d >"$CONFIG_PATH"

if [ ! -s "$CONFIG_PATH" ]; then
  log "[aceteam-hosted-entrypoint] error: decoded config is empty"
  exit 1
fi

log "[aceteam-hosted-entrypoint] exec openclaw gateway"
exec node /app/openclaw.mjs gateway
