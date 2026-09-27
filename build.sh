#!/usr/bin/env bash

set -euo pipefail

IMAGE="ips-patch-de10nano"
CONTAINER="ips-patch-de10nano-extract"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=============================================="
echo " ips-patch - DE10-Nano musl static build"
echo "=============================================="
echo

echo "[1/3] Building Docker image..."

docker build \
    --pull \
    -t "$IMAGE" \
    .

echo
echo "[2/3] Creating extraction container..."

docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

docker create \
    --name "$CONTAINER" \
    "$IMAGE" \
    >/dev/null

echo
echo "[3/3] Extracting binary..."

rm -f "$SCRIPT_DIR/ips-patch"

docker cp \
    "$CONTAINER:/src/target/armv7-unknown-linux-musleabihf/release/ips-patch" \
    "$SCRIPT_DIR/ips-patch"

docker rm "$CONTAINER" >/dev/null

chmod 755 "$SCRIPT_DIR/ips-patch"

echo
echo "=============================================="
echo " BUILD SUCCESSFUL"
echo "=============================================="

file "$SCRIPT_DIR/ips-patch"

echo
echo "SHA256:"
sha256sum "$SCRIPT_DIR/ips-patch"
