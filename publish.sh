#!/bin/sh
# Reject non-system dylibs, then upsert zips into the current-year release.
# Usage: publish.sh "<binaries>" "<zip globs>"
set -eu

if otool -L $1 | grep '\.dylib' | grep -vE '/usr/lib/'; then
  echo "FAIL: non-system dynamic library linked" >&2
  exit 1
fi

if [ "$GITHUB_EVENT_NAME" != "pull_request" ]; then
  YEAR=$(date -u +%Y)
  gh release view "$YEAR" >/dev/null 2>&1 \
    || gh release create "$YEAR" --title "$YEAR" --generate-notes || true
  gh release upload "$YEAR" $2 --clobber
fi
