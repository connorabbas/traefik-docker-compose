#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."

# create the file if missing, lock it down
[ -f acme.json ] || touch acme.json
chmod 600 acme.json

# then bring up Traefik
docker compose up -d
