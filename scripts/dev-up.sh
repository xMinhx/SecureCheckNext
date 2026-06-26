#!/usr/bin/env bash
# Dev environment helper for SecureCheck-Next.
#
# Wraps the multi-file docker-compose setup. The 3 compose files
# (docker-compose.yml, docker-compose-preview.yml, docker-compose.ci.yml)
# are intentionally separate for different environments.
#
# Usage:
#   scripts/dev-up.sh           # Start full preview stack (frontend + backend + db + smtp)
#   scripts/dev-up.sh down      # Stop the preview stack
#   scripts/dev-up.sh logs      # Tail logs from the preview stack
#   scripts/dev-up.sh ci        # Start CI stack (backend-prod + db + smtp + ldap)
#   scripts/dev-up.sh base      # Start base infra only (db + smtp + ldap)

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR=$(realpath "$SCRIPT_DIR/..")
cd "$BASE_DIR"

cmd="${1:-up}"
shift || true

case "$cmd" in
  up)
    echo "Starting preview stack (frontend + backend-dev + db + smtp)..."
    docker compose -f docker-compose.yml -f docker-compose-preview.yml up --build -d "$@"
    echo ""
    echo "Preview stack is up:"
    echo "  Frontend:    http://localhost:3000"
    echo "  Backend:     http://localhost:8005"
    echo "  PostgreSQL:  localhost:5432"
    echo "  MailDev UI:  http://localhost:1080"
    ;;
  ci)
    echo "Starting CI stack (backend-prod + db + smtp + ldap)..."
    docker compose -f docker-compose.yml -f docker-compose.ci.yml up --build -d "$@"
    echo ""
    echo "CI stack is up:"
    echo "  Backend:     http://localhost:8005"
    echo "  PostgreSQL:  localhost:5434"
    echo "  MailDev UI:  http://localhost:1085"
    echo "  LDAP:        localhost:390"
    ;;
  base)
    echo "Starting base infra (db + smtp + ldap)..."
    docker compose -f docker-compose.yml up -d "$@"
    echo ""
    echo "Base infra is up:"
    echo "  PostgreSQL:  localhost:5432"
    echo "  MailDev UI:  http://localhost:1080"
    echo "  LDAP:        localhost:390"
    ;;
  down)
    target="${1:-preview}"
    case "$target" in
      preview)
        echo "Stopping preview stack..."
        docker compose -f docker-compose.yml -f docker-compose-preview.yml down
        ;;
      ci)
        echo "Stopping CI stack..."
        docker compose -f docker-compose.yml -f docker-compose.ci.yml down
        ;;
      base)
        echo "Stopping base infra..."
        docker compose -f docker-compose.yml down
        ;;
      all)
        echo "Stopping all stacks..."
        docker compose -f docker-compose.yml -f docker-compose-preview.yml down 2>/dev/null || true
        docker compose -f docker-compose.yml -f docker-compose.ci.yml down 2>/dev/null || true
        docker compose -f docker-compose.yml down 2>/dev/null || true
        ;;
      *)
        echo "Unknown target: $target (use: preview|ci|base|all)"
        exit 1
        ;;
    esac
    ;;
  logs)
    docker compose -f docker-compose.yml -f docker-compose-preview.yml logs -f "$@"
    ;;
  *)
    echo "Usage: $0 [up|down|logs|ci|base] [args...]"
    echo ""
    echo "Commands:"
    echo "  up       Start the full preview stack (default)"
    echo "  down     Stop the preview stack (or: down ci|base|all)"
    echo "  logs     Tail logs from the preview stack"
    echo "  ci       Start the CI stack (backend-prod + db + smtp + ldap)"
    echo "  base     Start only base infra (db + smtp + ldap)"
    exit 1
    ;;
esac
