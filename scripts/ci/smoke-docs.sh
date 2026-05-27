#!/usr/bin/env bash
# smoke-docs.sh — Build-time invariant check for dossier output.
# Asserts $GH_PAGES/api/ looks plausibly correct before pushing.
# Run after scripts/ci/build-docs.sh. Exits non-zero on any failure.
# Requires bash >= 4 (uses mapfile).

set -euo pipefail

GH_PAGES="${1:-${GH_PAGES:-}}"
if [[ -z "$GH_PAGES" ]]; then
  echo "usage: $0 <gh-pages-worktree-path>  (or set \$GH_PAGES)" >&2
  exit 64
fi

API_DIR="$GH_PAGES/api"

# Check 1: api/index.html exists and is non-empty.
if [[ ! -s "$API_DIR/index.html" ]]; then
  echo "FAIL: $API_DIR/index.html missing or empty" >&2
  exit 1
fi

# Check 2: at least 1,400 .html files under api/.
HTML_COUNT=$(find "$API_DIR" -name '*.html' | wc -l | tr -d ' ')
MIN_FILES=1400
if (( HTML_COUNT < MIN_FILES )); then
  echo "FAIL: only $HTML_COUNT .html files in $API_DIR (need >= $MIN_FILES)" >&2
  exit 1
fi

# Check 3: 20 randomly sampled goog.*.html files each contain data-page-data=.
mapfile -t ALL_FILES < <(find "$API_DIR" -name 'goog.*.html')
if (( ${#ALL_FILES[@]} < 20 )); then
  echo "FAIL: only ${#ALL_FILES[@]} goog.*.html files (need >= 20 to sample)" >&2
  exit 1
fi
for _ in $(seq 1 20); do
  idx=$(( RANDOM % ${#ALL_FILES[@]} ))
  f="${ALL_FILES[$idx]}"
  if ! grep -q 'data-page-data="' "$f"; then
    echo "FAIL: $f has no data-page-data attribute" >&2
    exit 1
  fi
done

echo "OK: $HTML_COUNT .html files in $API_DIR, all 20 samples have data-page-data=\"…\""
