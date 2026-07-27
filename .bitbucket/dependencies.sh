#!/usr/bin/env sh

set -eu

# Add bash, make, docker-cli-compose
apk add --no-cache bash make docker-cli-compose

docker compose version
