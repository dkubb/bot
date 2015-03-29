#!/usr/bin/env bash

# Build local app

set -feuo pipefail
IFS=$'\n\t'

[ -r ./env.sh ] && source env.sh

if [ ! -d /app ]; then
  sudo mkdir -m 700 /app
  sudo chown "$USER" /app
fi

if [ ! -d /app/halcyon ]; then
  git clone https://github.com/mietek/halcyon.git /app/halcyon
fi

# Append the halcyon paths if they do not exist
path_config='source <(/app/halcyon/halcyon paths)'
grep -q -F "$path_config" ~/.profile || echo "$path_config" >> ~/.profile

halcyon build "$@"

ln -sf /app/sandbox/cabal.sandbox.config cabal.sandbox.config
