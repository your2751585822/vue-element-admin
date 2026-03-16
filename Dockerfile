# Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app

# 先安装 git（Alpine Linux 用 apk 包管理器）
RUN apk add --no-cache git

RUN npm config set registry https://registry.npmmirror.com
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build:prod

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
