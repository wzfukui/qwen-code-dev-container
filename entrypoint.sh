#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
QWEN_HOME="${QWEN_HOME:-/root/.qwen}"
TEMPLATE="/opt/qwen-dev/qwen-settings.template.json"
SETTINGS_FILE="${QWEN_HOME}/settings.json"

mkdir -p "${WORKSPACE_DIR}" "${QWEN_HOME}"

if [ ! -f "${SETTINGS_FILE}" ] && [ -f "${TEMPLATE}" ]; then
  cp "${TEMPLATE}" "${SETTINGS_FILE}"
fi

cd "${WORKSPACE_DIR}"

exec "$@"
