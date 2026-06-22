#!/bin/bash
set -euo pipefail

# Optional argument: file prefix
PREFIX="${1:-}"

# Parallelism (override by exporting JOBS, e.g. JOBS=4 ./script.sh)
JOBS="${JOBS:-15}"

# Make sure directory exists for the pdfs
mkdir -p pdfs

# The target for the created pdfs
OUTDIR="../pdfs"

cd slides

# Build file list safely (NUL-delimited for spaces)
if [ -n "$PREFIX" ]; then
  # Check if the user explicitly asked for index.html
  if [ "${PREFIX}.html" = "index.html" ]; then
    echo "Skipping index.html as requested."
    > /tmp/decktape_files.$$ # Create an empty file so the count check below handles the exit
  elif [ -f "${PREFIX}.html" ]; then
    printf '%s\0' "${PREFIX}.html" > /tmp/decktape_files.$$
  else
    echo "No matching HTML files found for prefix '${PREFIX}'"
    exit 1
  fi
else
  # all *.html in this directory EXCEPT index.html
  # (print0 handles spaces/newlines safely)
  find . -maxdepth 1 -type f -name '*.html' ! -name 'index.html' -print0 > /tmp/decktape_files.$$
fi

# Count files
count=$(tr -cd '\0' < /tmp/decktape_files.$$ | wc -c | tr -d ' ')
if [ "$count" -eq 0 ]; then
  echo "No matching HTML files found to process."
  rm -f /tmp/decktape_files.$$
  exit 1
fi

echo "Found $count HTML file(s). Running up to $JOBS parallel DeckTape job(s)..."
mkdir -p "$OUTDIR"

# Export for subshells invoked by xargs
export OUTDIR

# Convert in parallel
# -0 : read NUL-delimited
# -n1: one file per job
# -P : parallelism
# We use 'bash -c' so we can compute output filename per input.
cat /tmp/decktape_files.$$ \
  | xargs -0 -n 1 -P "$JOBS" bash -c '
      set -euo pipefail
      f="$1"
      # strip leading ./ if present
      f="${f#./}"
      out="$OUTDIR/${f%.html}.pdf"
      echo "[$(date +%H:%M:%S)] Starting: $f"
      decktape reveal "$f" "$out"
      echo "[$(date +%H:%M:%S)] Done:     $f -> $out"
    ' bash

rm -f /tmp/decktape_files.$$

echo "All done."
