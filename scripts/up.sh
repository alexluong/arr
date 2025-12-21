#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

STACKS=${1:-"all"}

cd "$PROJECT_DIR"

export DOCKER_CONTEXT="colima-arr"

case "$STACKS" in
  download)
    docker-compose -f compose/download.yaml --env-file .env up -d
    ;;
  arr)
    docker-compose -f compose/arr.yaml --env-file .env up -d
    ;;
  all)
    docker-compose -f compose/download.yaml -f compose/arr.yaml --env-file .env up -d
    ;;
  *)
    echo "Usage: up.sh [download|arr|all]"
    exit 1
    ;;
esac

echo "Stack '$STACKS' is up."
