#!/bin/sh
# Reject non-system dylibs, then upsert zips into the current-year release.
# Usage: publish.sh "<binaries or dirs>" "<zip globs>"; dirs are audited
# recursively for every Mach-O they ship.
set -eu

targets=""
for p in $1; do
  if [ -d "$p" ]; then
    for f in $(find "$p" -type f); do
      if file "$f" | grep -q Mach-O; then targets="$targets $f"; fi
    done
  else
    targets="$targets $p"
  fi
done
[ -n "$targets" ] || { echo "no binaries to audit" >&2; exit 1; }

otool -L $targets
if otool -L $targets | grep '\.dylib' | grep -vE '/usr/lib/'; then
  echo "FAIL: non-system dynamic library linked" >&2
  exit 1
fi

if [ "$GITHUB_EVENT_NAME" != "pull_request" ]; then
  YEAR=$(date -u +%Y)
  gh release view "$YEAR" >/dev/null 2>&1 \
    || gh release create "$YEAR" --title "$YEAR" --generate-notes || true
  gh release upload "$YEAR" $2 --clobber
fi
