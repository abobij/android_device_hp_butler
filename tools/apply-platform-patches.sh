#!/usr/bin/env bash
set -euo pipefail

device_tree=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
tree=$(cd -- "$device_tree/../.." && pwd -P)

exec 3<"$device_tree/patch-revisions.tsv"
pending=()
while IFS=$'\t' read -r project base patched_tree <&3; do
  repo="$tree/$project"
  if [[ $(git -C "$repo" rev-parse 'HEAD^{tree}') == "$patched_tree" ]]; then
    continue
  fi
  if [[ $(git -C "$repo" rev-parse HEAD) != "$base" ]] ||
     ! git -C "$repo" diff --quiet ||
     ! git -C "$repo" diff --cached --quiet; then
    printf '%s: expected a clean checkout at %s\n' "$project" "$base" >&2
    exit 1
  fi
  pending+=("$project")
done
exec 3<&-

for project in "${pending[@]}"; do
  git -C "$tree/$project" am "$device_tree/patches/$project/"*.patch
done
