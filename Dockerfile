# Sử dụng Node.js chính thức từ Docker Hub
FROM node:18

# Tạo thư mục làm việc cho ứng dụng
WORKDIR /app

# Copy file package.json và yarn.lock (nếu có) vào container
COPY package.json yarn.lock ./

# Nếu package.json không tồn tại, khởi tạo dự án Nuxt 3
RUN [ ! -f package.json ] && npx nuxi init . || echo "Nuxt project already exists"

# Cài đặt các dependencies
RUN yarn install --frozen-lockfile

# Copy tất cả mã nguồn của ứng dụng vào container
COPY . .

# Build ứng dụng Nuxt 3
RUN yarn build

# Xóa các file không cần thiết sau khi build để giảm kích thước image
RUN rm -rf node_modules && yarn install --production

# Mở port mà Nuxt sẽ chạy trên container
EXPOSE 3000

# Chạy ứng dụng
CMD ["yarn", "preview"]
