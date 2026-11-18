#!/bin/sh
# Shared tail for every job in .github/workflows/build.yml: codesign the
# built binaries, reject non-system dylibs, and upsert the zips into the
# release named for the current year. The workflow artifact upload is a
# per-job uses: step and stays in build.yml.
#
# Usage: scripts/publish.sh "<binaries>" "<zip globs>"
# Set PUBLISH=0 to skip the release upload (pull_request builds).

set -eu

binaries=$1
zips=$2

codesign --force --sign - $binaries
file $binaries
lipo -info $binaries
otool -L $binaries
if otool -L $binaries | grep '\.dylib' | grep -vE '/usr/lib/'; then
  echo "FAIL: non-system dynamic library linked" >&2
  exit 1
fi

if [ "${PUBLISH:-1}" = "1" ]; then
  YEAR=$(date -u +%Y)
  gh release view "$YEAR" >/dev/null 2>&1 \
    || gh release create "$YEAR" --title "$YEAR" --generate-notes || true
  gh release upload "$YEAR" $zips --clobber
fi
