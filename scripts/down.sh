#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

STACKS=${1:-"all"}

cd "$PROJECT_DIR"

DOCKER="docker --context colima-arr"

case "$STACKS" in
  download)
    $DOCKER compose -f compose/download.yaml --env-file .env down
    ;;
  arr)
    $DOCKER compose -f compose/arr.yaml --env-file .env down
    ;;
  all)
    $DOCKER compose -f compose/download.yaml -f compose/arr.yaml --env-file .env down
    ;;
  *)
    echo "Usage: down.sh [download|arr|all]"
    exit 1
    ;;
esac

echo "Stack '$STACKS' is down."
