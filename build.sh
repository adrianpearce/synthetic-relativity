#!/usr/bin/env bash
set -euo pipefail

# Optional argument: file prefix (default to empty)
PREFIX="${1:-}"

# Always run from repo root (important if script is called elsewhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# echo "==> Rendering book"
# quarto render --profile book

echo "==> Rendering slides"
quarto render --profile slides

#echo "==> Running DeckTape batch"
#./batch-decktape-parallel.sh "$PREFIX"

echo "==> Publishing book"
quarto publish --profile book gh-pages --no-prompt 

