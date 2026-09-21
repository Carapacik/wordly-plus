#!/bin/sh
set -eu

drift_version='2.35.0'
worker_sha256='df0066e75363a9bed59a14eedbbded421c1f5910f8379812df164716aa2e6eed'
wasm_sha256='13d3f11d05b39ba0618a7115fb41640a5d48b6300f5d3f325f554b42bd6688a4'
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
locked_drift_version=$(awk '/^  drift:$/ { found=1; next } found && /version:/ { gsub(/"/, "", $2); print $2; exit }' "$project_dir/pubspec.lock")
if [ "$locked_drift_version" != "$drift_version" ]; then
  echo "Drift web assets ($drift_version) do not match pubspec.lock ($locked_drift_version). Update the pinned release and checksums." >&2
  exit 1
fi
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
