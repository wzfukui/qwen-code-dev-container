#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${1:-qwen-code-dev:0.13.3}"
WORKSPACE_DIR="${2:-$(pwd)}"

if [ -z "${DASHSCOPE_API_KEY:-}" ]; then
  echo "DASHSCOPE_API_KEY is required" >&2
  exit 1
fi

MODELS=(
  "qwen3-30b-a3b-instruct-2507"
  "deepseek-v3"
  "qwen3.5-35b-a3b"
)

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

for model in "${MODELS[@]}"; do
  python3 - <<PY
import json
model = ${model@Q}
data = {
    "modelProviders": {
        "openai": [
            {
                "id": model,
                "name": model,
                "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
                "envKey": "DASHSCOPE_API_KEY",
            }
        ]
    },
    "security": {"auth": {"selectedType": "openai"}},
    "model": {"name": model},
}
with open(${TMP_DIR@Q} + "/settings.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
PY

  echo "=== Testing ${model} ==="
  docker run --rm \
    -e DASHSCOPE_API_KEY \
    -e HTTP_PROXY \
    -e HTTPS_PROXY \
    -e NO_PROXY \
    -v "${WORKSPACE_DIR}:/workspace" \
    -v "${TMP_DIR}/settings.json:/root/.qwen/settings.json:ro" \
    "${IMAGE_TAG}" \
    qwen -p "Reply with OK only."
  echo
done
