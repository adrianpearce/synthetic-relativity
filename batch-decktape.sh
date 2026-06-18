#!/bin/bash

# Exit on error
set -e

# Optional argument: file prefix
PREFIX="$1"


# Make sure directory exists for the pdfs
mkdir -p pdfs

cd slides

# Determine files to process
if [ -n "$PREFIX" ]; then
  FILES=${PREFIX}.html
else
  FILES=*.html
fi

# Process each file
found=false
for f in $FILES; do
  if [ -f "$f" ]; then
    found=true
    echo "Processing $f..."
    decktape reveal "$f" "../pdfs/${f%.html}.pdf"
  fi
done

# Handle case where no files matched
if [ "$found" = false ]; then
  echo "No matching HTML files found for prefix '${PREFIX}'"
  exit 1
fi
