#!/bin/bash
# Build the web (GitHub Pages) version of Classic Football Manager.
# Output: web/dist/ — a static site (serve it locally, or let the Pages
# workflow in .github/workflows/pages.yml build + deploy it automatically).
#
# One-time setup: Rust stable with the wasm32-unknown-unknown target,
# wasm-pack, and Node 20+.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$HOME/.cargo/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

command -v cargo >/dev/null || { echo "Rust (cargo) not found — install from https://rustup.rs"; exit 1; }
command -v rustup >/dev/null || { echo "rustup not found — install from https://rustup.rs"; exit 1; }
command -v npm >/dev/null || { echo "Node.js (npm) not found — install from https://nodejs.org"; exit 1; }
command -v wasm-pack >/dev/null || { echo "wasm-pack not found — run: cargo install wasm-pack"; exit 1; }
rustup target list --installed 2>/dev/null | grep -q wasm32-unknown-unknown \
  || rustup target add wasm32-unknown-unknown

echo "==> [1/3] Building the Rust engine to WebAssembly"
wasm-pack build "$ROOT/apps/web" \
  --target web --out-dir ../desktop/src/wasm-pkg --out-name cm_web

echo "==> [2/3] Building the Svelte frontend (web mode)"
npm --prefix "$ROOT/apps/desktop" run build:web

echo "==> [3/3] Verifying output"
test -f "$ROOT/web/dist/index.html" || { echo "index.html missing"; exit 1; }
test -f "$ROOT/web/dist/wasm-pkg/cm_web_bg.wasm" || { echo "WASM missing"; exit 1; }
du -sh "$ROOT/web/dist"
echo
echo "Done: $ROOT/web/dist — serve it (e.g. python3 -m http.server) or push"
echo "to GitHub and enable Pages with the workflow in .github/workflows/."
