#!/usr/bin/env bash

GH_BOT_TOKEN=$1
BOT_WORKSPACE="/home/bot/bot-workspace"
SCRIPT_PATH="/home/bot/jenkins-scripts"

rsync -a "$GITHUB_WORKSPACE/" "$BOT_WORKSPACE"
chown -R bot:bot /home/bot/
chown -R bot:bot /tmp

# Setup tribe-jenkins-scripts
gosu bot bash -c "git clone --depth 1 --branch master --single-branch https://$GH_BOT_USER:$GH_BOT_TOKEN@github.com/the-events-calendar/jenkins-scripts.git $SCRIPT_PATH"

cd $SCRIPT_PATH
gosu bot bash -c "composer install -o --ignore-platform-reqs"
gosu bot bash -c "chmod +x mt-jenkins"
sed "s/oauth_token: ''/oauth_token: '$GH_BOT_TOKEN'/" script-config-sample.yml > $SCRIPT_PATH/script-config.yml
chown bot:bot $SCRIPT_PATH/script-config.yml

cd $BOT_WORKSPACE

# Alias PHP to the path our mt-jenkins scripts expect
ln -s $(which php) /usr/bin/php

PR=$(cat $GITHUB_EVENT_PATH | jq '.number')

echo "Repo: $GITHUB_REPOSITORY"
echo "PR: $PR"
echo "Path: $BOT_WORKSPACE"

# Run codesniffing
$SCRIPT_PATH/mt-jenkins code-review --repo=$GITHUB_REPOSITORY --pr=$(cat $GITHUB_EVENT_PATH | jq '.number') --path=$BOT_WORKSPACE -vvv
