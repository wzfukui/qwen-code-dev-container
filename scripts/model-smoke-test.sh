#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${1:-qwen-code-dev:0.17.1}"
WORKSPACE_DIR="${2:-$(pwd)}"

SMOKE_AUTH_TYPE="${SMOKE_AUTH_TYPE:-openai}"
SMOKE_API_KEY="${SMOKE_API_KEY:-${DEEPSEEK_API_KEY:-${DASHSCOPE_API_KEY:-}}}"
USER_SMOKE_API_BASE_URL="${SMOKE_API_BASE_URL:-}"

if [ -z "${SMOKE_API_KEY}" ]; then
  echo "SMOKE_API_KEY is required. You can also set DEEPSEEK_API_KEY or DASHSCOPE_API_KEY." >&2
  exit 1
fi

if [ "${SMOKE_AUTH_TYPE}" != "openai" ] && [ "${SMOKE_AUTH_TYPE}" != "anthropic" ]; then
  echo "Unsupported SMOKE_AUTH_TYPE: ${SMOKE_AUTH_TYPE}" >&2
  echo "Supported auth types: openai, anthropic" >&2
  exit 1
fi

if [ -n "${SMOKE_MODELS:-}" ]; then
  read -r -a MODELS <<<"${SMOKE_MODELS}"
elif [ -n "${DASHSCOPE_API_KEY:-}" ] && [ -z "${DEEPSEEK_API_KEY:-}" ]; then
  MODELS=(
    "qwen3-30b-a3b-instruct-2507"
    "deepseek-v3"
    "qwen3.5-35b-a3b"
  )
  SMOKE_API_BASE_URL="${USER_SMOKE_API_BASE_URL:-https://dashscope.aliyuncs.com/compatible-mode/v1}"
else
  MODELS=(
    "deepseek-v4-flash"
    "deepseek-v4-pro"
  )
  if [ "${SMOKE_AUTH_TYPE}" = "anthropic" ]; then
    SMOKE_API_BASE_URL="${USER_SMOKE_API_BASE_URL:-https://api.deepseek.com/anthropic}"
  else
    SMOKE_API_BASE_URL="${USER_SMOKE_API_BASE_URL:-https://api.deepseek.com}"
  fi
fi

if [ -z "${SMOKE_API_BASE_URL:-}" ]; then
  if [ "${SMOKE_AUTH_TYPE}" = "anthropic" ]; then
    SMOKE_API_BASE_URL="${USER_SMOKE_API_BASE_URL:-https://api.deepseek.com/anthropic}"
  else
    SMOKE_API_BASE_URL="${USER_SMOKE_API_BASE_URL:-https://api.deepseek.com}"
  fi
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

for model in "${MODELS[@]}"; do
  AUTH_TYPE="${SMOKE_AUTH_TYPE}" \
  BASE_URL="${SMOKE_API_BASE_URL}" \
  MODEL_NAME="${model}" \
  TMP_DIR="${TMP_DIR}" \
  python3 - <<'PY'
import json
import os
from pathlib import Path

auth_type = os.environ["AUTH_TYPE"]
model = os.environ["MODEL_NAME"]
data = {
    "modelProviders": {
        auth_type: [
            {
                "id": model,
                "name": model,
                "baseUrl": os.environ["BASE_URL"],
                "envKey": "SMOKE_API_KEY",
            }
        ]
    },
    "security": {"auth": {"selectedType": auth_type}},
    "model": {"name": model},
}
Path(os.environ["TMP_DIR"], "settings.json").write_text(
    json.dumps(data, ensure_ascii=False, indent=2),
    encoding="utf-8",
)
PY

  echo "=== Testing ${SMOKE_AUTH_TYPE} ${model} ==="
  docker run --rm \
    -e SMOKE_API_KEY="${SMOKE_API_KEY}" \
    -e HTTP_PROXY="${HTTP_PROXY:-}" \
    -e HTTPS_PROXY="${HTTPS_PROXY:-}" \
    -e NO_PROXY="${NO_PROXY:-}" \
    -v "${WORKSPACE_DIR}:/workspace" \
    -v "${TMP_DIR}/settings.json:/root/.qwen/settings.json:ro" \
    "${IMAGE_TAG}" \
    qwen -p "Reply with OK only."
  echo
done
