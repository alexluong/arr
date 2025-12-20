#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

STACKS=${1:-"all"}

cd "$PROJECT_DIR"

DOCKER="docker --context colima-arr"

case "$STACKS" in
  download)
    $DOCKER compose -f compose/download.yaml --env-file .env up -d
    ;;
  arr)
    $DOCKER compose -f compose/arr.yaml --env-file .env up -d
    ;;
  all)
    $DOCKER compose -f compose/download.yaml -f compose/arr.yaml --env-file .env up -d
    ;;
  *)
    echo "Usage: up.sh [download|arr|all]"
    exit 1
    ;;
esac

echo "Stack '$STACKS' is up."
