echo "Building Nuxt app, tag $TAG"

# Exit on error
set -e

# Enable debug
set -x

# Cat env content from Jenkins Credentials to .env file
cat $ENV_FILE > ./.env

# Install dependencies
export PATH="$PATH:/usr/local/bin"
yarn install --frozen-lockfile

# Build Nuxt app
yarn build

# Prepare for deployment
rm -rf .output.zip
zip -r .output.zip .output

OUT=$?
set +x

if [ $OUT -eq 0 ]; then
    echo "Nuxt app build completed successfully."
    exit 0
else
    echo "Failure: Nuxt app build failed."
    exit 1
fi