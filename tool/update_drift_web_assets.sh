#!/bin/sh
set -eu

drift_version='2.34.3'
worker_sha256='4db0469de8ceabad8d5cd3d920614486ba587e100e39523f36f704a3aec5f26c'
wasm_sha256='41cf968998241465d8b1dfffb1eb60dd10c35de5022a3647e14174ea3af84143'
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
download_dir=$(mktemp -d)
trap 'rm -rf "$download_dir"' EXIT HUP INT TERM

curl -fsSL "https://github.com/simolus3/drift/releases/download/drift-${drift_version}/drift_worker.js" \
  -o "$download_dir/drift_worker.js"
curl -fsSL "https://github.com/simolus3/drift/releases/download/drift-${drift_version}/sqlite3.wasm" \
  -o "$download_dir/sqlite3.wasm"

printf '%s  %s\n' "$worker_sha256" "$download_dir/drift_worker.js" | shasum -a 256 -c -
printf '%s  %s\n' "$wasm_sha256" "$download_dir/sqlite3.wasm" | shasum -a 256 -c -
mv "$download_dir/drift_worker.js" "$project_dir/web/drift_worker.js"
mv "$download_dir/sqlite3.wasm" "$project_dir/web/sqlite3.wasm"
