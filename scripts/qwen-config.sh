#!/usr/bin/env bash
set -euo pipefail

QWEN_HOME="${QWEN_HOME:-/root/.qwen}"
SETTINGS_FILE="${QWEN_HOME}/settings.json"

if [ "${1:-}" = "" ] || [ "${2:-}" = "" ] || [ "${3:-}" = "" ]; then
  cat <<'USAGE' >&2
Usage:
  qwen-config <base_url> <api_key> <model_name> [provider_name]

Example:
  qwen-config https://dashscope.aliyuncs.com/compatible-mode/v1 sk-xxxx qwen3-30b-a3b-instruct-2507 "Field Model"
USAGE
  exit 1
fi

BASE_URL="$1"
API_KEY="$2"
MODEL_NAME="$3"
PROVIDER_NAME="${4:-$MODEL_NAME}"

mkdir -p "${QWEN_HOME}"

python3 - <<PY
import json
from pathlib import Path

settings_path = Path("${SETTINGS_FILE}")
payload = {
    "modelProviders": {
        "openai": [
            {
                "id": "${MODEL_NAME}",
                "name": "${PROVIDER_NAME}",
                "baseUrl": "${BASE_URL}",
                "description": "OpenAI-compatible endpoint",
                "envKey": "LLM_API_KEY",
            }
        ]
    },
    "env": {
        "LLM_API_KEY": "${API_KEY}",
    },
    "security": {
        "auth": {
            "selectedType": "openai",
        }
    },
    "model": {
        "name": "${MODEL_NAME}",
    },
}
settings_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"written: {settings_path}")
PY
