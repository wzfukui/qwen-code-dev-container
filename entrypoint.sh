#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
QWEN_HOME="${QWEN_HOME:-/root/.qwen}"

mkdir -p "${WORKSPACE_DIR}" "${QWEN_HOME}"

cd "${WORKSPACE_DIR}"

exec "$@"
