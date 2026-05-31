#!/usr/bin/env bash
set -euo pipefail

QWEN_HOME="${QWEN_HOME:-/root/.qwen}"
SETTINGS_FILE="${QWEN_HOME}/settings.json"

AUTH_TYPE="openai"

case "${1:-}" in
  --auth-type)
    AUTH_TYPE="${2:-}"
    shift 2
    ;;
  --anthropic)
    AUTH_TYPE="anthropic"
    shift
    ;;
  --openai)
    AUTH_TYPE="openai"
    shift
    ;;
esac

if [ "${AUTH_TYPE}" != "openai" ] && [ "${AUTH_TYPE}" != "anthropic" ]; then
  echo "Unsupported auth type: ${AUTH_TYPE}" >&2
  echo "Supported auth types: openai, anthropic" >&2
  exit 1
fi

if [ "${1:-}" = "" ] || [ "${2:-}" = "" ] || [ "${3:-}" = "" ]; then
  cat <<'USAGE' >&2
Usage:
  qwen-config [--auth-type openai|anthropic] <base_url> <api_key> <model_name> [provider_name]

Examples:
  qwen-config https://api.deepseek.com sk-xxxx deepseek-v4-flash "DeepSeek V4 Flash"
  qwen-config --auth-type anthropic https://api.deepseek.com/anthropic sk-xxxx deepseek-v4-pro "DeepSeek V4 Pro"
USAGE
  exit 1
fi

BASE_URL="$1"
API_KEY="$2"
MODEL_NAME="$3"
PROVIDER_NAME="${4:-$MODEL_NAME}"
export AUTH_TYPE BASE_URL API_KEY MODEL_NAME PROVIDER_NAME SETTINGS_FILE

mkdir -p "${QWEN_HOME}"

python3 - <<'PY'
import os
import json
from pathlib import Path

auth_type = os.environ["AUTH_TYPE"]
api_key_env = "LLM_API_KEY"
settings_path = Path(os.environ["SETTINGS_FILE"])
payload = {
    "modelProviders": {
        auth_type: [
            {
                "id": os.environ["MODEL_NAME"],
                "name": os.environ["PROVIDER_NAME"],
                "baseUrl": os.environ["BASE_URL"],
                "description": f"{auth_type} endpoint",
                "envKey": api_key_env,
            }
        ]
    },
    "env": {
        api_key_env: os.environ["API_KEY"],
    },
    "security": {
        "auth": {
            "selectedType": auth_type,
        }
    },
    "model": {
        "name": os.environ["MODEL_NAME"],
    },
}
settings_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"written: {settings_path}")
PY
