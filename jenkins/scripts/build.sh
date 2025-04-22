#!/bin/bash
set -e
set -x

echo "Building Nuxt app, tag $TAG"

# cat "$ENV_FILE" > .env
#Build
export PATH="$PATH:/usr/local/bin"
yarn install --frozen-lockfile
yarn build

rm -rf .output.zip
zip -r .output.zip .output

OUT=$?
set +x

if [ $OUT -eq 0 ]; then
    exit 0
else
    echo 'Failure: app build'
    exit 1
fi
