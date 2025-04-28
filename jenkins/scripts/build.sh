#!/bin/bash
set -e
set -x

echo "Building Nuxt app, tag $TAG"

export PATH="$PATH:/usr/local/bin"
yarn install --frozen-lockfile

yarn test

yarn build

if [ -d ".output" ]; then
    rm -rf .output.zip
    zip -r output.zip .output
else
    echo ".output directory does not exist!"
    exit 1
fi

OUT=$?
set +x

if [ $OUT -eq 0 ]; then
    exit 0
else
    echo '===============Failure: app build================'
    exit 1
fi
