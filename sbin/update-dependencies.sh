#!/usr/bin/env bash

# Update dependencies

set -feuo pipefail
IFS=$'\n\t'

[ -r ./env.sh ] && source env.sh

echo 'Update application dependencies'
halcyon constraints 2>/dev/null | sort -u > .halcyon/constraints

echo 'Update sandbox extra app dependencies'
xargs -I{} sh -c "
  echo 'Update {} dependencies' && \
  halcyon constraints {} 2>/dev/null \
    | sort -u > .halcyon/sandbox-extra-apps-constraints/{}.constraints
" < .halcyon/sandbox-extra-apps
