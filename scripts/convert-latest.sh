#!/usr/bin/env bash

set -e

UPSTREAM_REPO=ComponentDriven/csf
REPO_DIR_NAME=$(basename $UPSTREAM_REPO)
BUILD_DIR=build/

echo "info: Creating $BUILD_DIR directory..."
mkdir -p $BUILD_DIR

function clone_or_pull_repo {
    # $1: repo owner + name, i.e. "ComponentDriven/csf"
    echo "info: Cloning $1 into $BUILD_DIR..."
    repo_name=$(basename $1)
    repo_path="$BUILD_DIR/$repo_name"

    if [ -d "$DIRECTORY" ]; then
        echo "info: Repo already cloned. Pulling latest changes..."
        (cd $repo_path && git pull)
    else
        git clone $1 $repo_path
    fi
}

echo "info: Cloning Git repos..."
clone_or_pull_repo Roblox/js-to-lua
clone_or_pull_repo $UPSTREAM_REPO

echo "info: Building js-to-lua"
cd js-to-lua
npm install
npm run build:prod

runner=$(realpath dist/apps/convert-js-to-lua/main.js)
cd ..

echo "info: Path to js-to-lua: $runner"

echo "info: Converting $UPSTREAM_REPO to Luau..."
node $runner --input $REPO_DIR_NAME/**/*.ts --output .

echo "info: Successfully converted $UPSTREAM_REPO"