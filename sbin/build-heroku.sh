#!/usr/bin/env bash

# Build heroku app

set -feuo pipefail
IFS=$'\n\t'

[ -r ./env.sh ] && source env.sh

# Sync the latest code with heroku
git push --quiet --force -- "$ORIGIN" "$BRANCH:master"

# Build the system on a larger heroku instance
heroku run --size PX -- build "$@"

# Trigger a deployment with the new build
git commit --quiet --amend --no-edit
git push --quiet --force -- "$ORIGIN" "$BRANCH:master"

# Start up a web worker
heroku ps:scale web=1

# Test the new build
heroku apps:open --app "$APP_NAME"
