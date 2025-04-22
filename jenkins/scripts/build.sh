#!/bin/bash

echo "Building Nuxt app, tag $TAG"

# Exit on error
set -e

# Enable debug
set -x

# Cat env content from Jenkins Credentials to .env file
# cat "$ENV_FILE" > ./.env

# Debug: show PATH and yarn location
echo "Current PATH: $PATH"
which yarn || {
  echo "❌ 'yarn' not found. Please make sure it's installed in your Jenkins agent or Docker image."
  exit 1
}

# Install dependencies
yarn install --frozen-lockfile

# Build Nuxt app
yarn build

# Prepare for deployment
rm -rf .output.zip
zip -r .output.zip .output

OUT=$?
set +x

if [ $OUT -eq 0 ]; then
    echo "✅ Nuxt app build completed successfully."
    exit 0
else
    echo "❌ Failure: Nuxt app build failed."
    exit 1
fi
