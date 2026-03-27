#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
QWEN_HOME="${QWEN_HOME:-/root/.qwen}"
TEMPLATE="/opt/qwen-dev/qwen-settings.template.json"
SETTINGS_FILE="${QWEN_HOME}/settings.json"
LLM_API_BASE="${LLM_API_BASE:-}"
LLM_API_KEY="${LLM_API_KEY:-}"
LLM_MODEL="${LLM_MODEL:-}"
LLM_PROVIDER_NAME="${LLM_PROVIDER_NAME:-OpenAI-Compatible Model}"

mkdir -p "${WORKSPACE_DIR}" "${QWEN_HOME}"

if [ -n "${LLM_API_BASE}" ] && [ -n "${LLM_API_KEY}" ] && [ -n "${LLM_MODEL}" ]; then
  cat > "${SETTINGS_FILE}" <<EOF
{
  "modelProviders": {
    "openai": [
      {
        "id": "${LLM_MODEL}",
        "name": "${LLM_PROVIDER_NAME}",
        "baseUrl": "${LLM_API_BASE}",
        "description": "OpenAI-compatible endpoint from environment variables",
        "envKey": "LLM_API_KEY"
      }
    ]
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "${LLM_MODEL}"
  }
}
EOF
elif [ ! -f "${SETTINGS_FILE}" ] && [ -f "${TEMPLATE}" ]; then
  cp "${TEMPLATE}" "${SETTINGS_FILE}"
fi

cd "${WORKSPACE_DIR}"

exec "$@"
