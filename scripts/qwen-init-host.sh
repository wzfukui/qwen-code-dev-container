#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${IMAGE_TAG:-qwen-code-dev:0.13.4}"
CONTAINER_NAME="${CONTAINER_NAME:-qwen-dev}"
WORKSPACE_HOST_DIR="${WORKSPACE_HOST_DIR:-/data/project}"
QWEN_HOME_DIR="${QWEN_HOME_DIR:-/data/qwen-home}"

mkdir -p "${WORKSPACE_HOST_DIR}" "${QWEN_HOME_DIR}"

docker run --rm \
  -v "${QWEN_HOME_DIR}:/root/.qwen" \
  "${IMAGE_TAG}" \
  sh -lc 'cp -n /opt/qwen-dev/qwen-settings.template.json /root/.qwen/settings.json'

docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true

docker run -it \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -v "${WORKSPACE_HOST_DIR}:/workspace" \
  -v "${QWEN_HOME_DIR}:/root/.qwen" \
  "${IMAGE_TAG}"
