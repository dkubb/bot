#!/usr/bin/env bash

# Set up application

set -feuo pipefail
IFS=$'\n\t'

current_app=$(heroku apps:info 2> /dev/null | grep -Po '(?<==== )([a-z-]+)')

read -e -p "app name: " -i "$current_app" APP_NAME

# Join the app if not already
if [ "$current_app" != "$APP_NAME" ]; then
  heroku join --app "$APP_NAME"
fi

# Prompt the user for application settings
read -e -p "aws access key id: "     -i "$(heroku config:get HALCYON_AWS_ACCESS_KEY_ID)"             HALCYON_AWS_ACCESS_KEY_ID
read -e -p "aws secret access key: " -i "$(heroku config:get HALCYON_AWS_SECRET_ACCESS_KEY)"         HALCYON_AWS_SECRET_ACCESS_KEY
read -e -p "aws s3 bucket name: "    -i "$(heroku config:get HALCYON_S3_BUCKET || echo "$APP_NAME")" HALCYON_S3_BUCKET

echo "Adding git remote for heroku to $APP_NAME"
heroku git:remote --app "$APP_NAME"

echo 'Setting heroku environment'
heroku config:set \
  "APP_NAME=$APP_NAME" \
  "HALCYON_AWS_ACCESS_KEY_ID=$HALCYON_AWS_ACCESS_KEY_ID" \
  "HALCYON_AWS_SECRET_ACCESS_KEY=$HALCYON_AWS_SECRET_ACCESS_KEY" \
  "HALCYON_S3_BUCKET=$HALCYON_S3_BUCKET" \
  'HALCYON_CABAL_VERSION=1.22.2.0'

echo 'Add heroku plugin to report exit code from run command'
heroku plugins:install https://github.com/goodeggs/heroku-exit-status.git

echo 'Creating ./env.sh'
cat <<-EOF > env.sh
export APP_NAME='$APP_NAME'

export ORIGIN='heroku'
export REMOTE_URL='$(git config --get remote.heroku.url)'
export BRANCH="\$(git rev-parse --abbrev-ref HEAD)"

export HALCYON_AWS_ACCESS_KEY_ID='$HALCYON_AWS_ACCESS_KEY_ID'
export HALCYON_AWS_SECRET_ACCESS_KEY='$HALCYON_AWS_SECRET_ACCESS_KEY'
export HALCYON_S3_BUCKET='$HALCYON_S3_BUCKET'
export HALCYON_CABAL_VERSION='1.22.2.0'
EOF

echo 'Setup complete'
