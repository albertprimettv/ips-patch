#!/bin/sh
set -eu

TARGET="${TARGET:-armv7-unknown-linux-musleabihf}"

export CARGO_BUILD_TARGET="${TARGET}"

export RUSTFLAGS="${RUSTFLAGS:--C target-cpu=cortex-a9 -C target-feature=+neon}"

echo "========================================"
echo " DE10-Nano Rust/musl build"
echo "========================================"
echo "TARGET    = ${TARGET}"
echo "RUSTFLAGS = ${RUSTFLAGS}"
echo

cargo build \
    --release \
    --target="${TARGET}"

echo
echo "========================================"
echo " BUILD RESULT"
echo "========================================"

ls -lh "target/${TARGET}/release/ips-patch"
