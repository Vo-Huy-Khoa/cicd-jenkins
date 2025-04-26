#!/bin/bash
set -e
set -x

echo "Building Nuxt app, tag $TAG"

# Nếu ENV_FILE cần thiết, có thể uncomment dòng dưới đây
# cat "$ENV_FILE" > .env

# Cài đặt dependencies và build Nuxt 3 app
export PATH="$PATH:/usr/local/bin"
yarn install --frozen-lockfile
yarn build

# Chạy test
yarn test

# Kiểm tra xem thư mục .output có được tạo ra không và zip lại
if [ -d ".output" ]; then
    rm -rf .output.zip
    zip -r .output.zip .output
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
