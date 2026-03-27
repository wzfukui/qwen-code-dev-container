#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${1:-qwen-code-dev:0.13.1}"
OUTPUT_PATH="${2:-./image/qwen-code-dev-0.13.1.tar.gz}"

mkdir -p "$(dirname "${OUTPUT_PATH}")"
docker save "${IMAGE_TAG}" | gzip > "${OUTPUT_PATH}"
echo "saved: ${OUTPUT_PATH}"
