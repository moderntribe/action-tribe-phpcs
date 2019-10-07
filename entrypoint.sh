#!/usr/bin/env bash

GH_BOT_TOKEN=$1
BOT_WORKSPACE="/home/tr1b0t/bot-workspace"
SCRIPT_PATH="/home/tr1b0t/tribe-jenkins-scripts"

rsync -a "$GITHUB_WORKSPACE/" "$BOT_WORKSPACE"
chown -R tr1b0t:tr1b0t /home/tr1b0t/
chown -R tr1b0t:tr1b0t /tmp

# Setup tribe-jenkins-scripts
gosu tr1b0t bash -c "git clone --depth 1 --branch master --single-branch https://tr1b0t:$GH_BOT_TOKEN@github.com/moderntribe/tribe-jenkins-scripts.git $SCRIPT_PATH"

cd $SCRIPT_PATH
gosu tr1b0t bash -c "composer update -o"
gosu tr1b0t bash -c "chmod +x mt-jenkins"
sed "s/oauth_token: ''/oauth_token: '$GH_BOT_TOKEN'/" script-config-sample.yml > $SCRIPT_PATH/script-config.yml
chown tr1b0t:tr1b0t $SCRIPT_PATH/script-config.yml

cd $BOT_WORKSPACE

# Alias PHP to the path our mt-jenkins scripts expect
ln -s $(which php) /usr/bin/php

# Run codesniffing
$SCRIPT_PATH/mt-jenkins code-review --repo=$GITHUB_REPOSITORY --pr=$(cat $GITHUB_EVENT_PATH | jq '.number') --path=$BOT_WORKSPACE
