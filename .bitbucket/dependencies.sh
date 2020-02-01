#!/usr/bin/env sh

set -eu

# Add python pip and bash
apk add --no-cache py-pip bash make

# Install docker-compose via pip
pip install --no-cache-dir docker-compose~=1.23.0
docker-compose -v
