#!/usr/bin/env bash

# Build local app

set -feuo pipefail
IFS=$'\n\t'

[ -r ./env.sh ] && source env.sh

if [ ! -d "$HALCYON_BASE" ]; then
  sudo mkdir -m 700 "$HALCYON_BASE"
  sudo chown "$USER" "$HALCYON_BASE"
fi

if [ ! -d "$HALCYON_BASE/halcyon" ]; then
  git clone https://github.com/mietek/halcyon.git "$HALCYON_BASE/halcyon"
fi

# Append the halcyon paths if they do not exist
path_config="source <($HALCYON_BASE/halcyon/halcyon paths)"
grep -q -F "$path_config" ~/.profile || echo "$path_config" >> ~/.profile

# Update the halcyon paths for this process
eval "$path_config"

halcyon build "$@"

ln -sf "$HALCYON_BASE/sandbox/cabal.sandbox.config" cabal.sandbox.config
