# Stage 1: build Vue app from current source
FROM node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
# Project has Vue2 peer deps (lucide-vue, element-ui) on a Vue3 app
RUN npm ci --legacy-peer-deps

COPY . .

# Production API — direct to backend (browser shows :3003 in Network tab)
ENV VITE_API_URL=http://10.82.126.25:3004/api/v1
# Must stay empty in production. If set, apiServices.js prefers it over VITE_API_URL
# and a value without /api/v1 makes login hit :3003/auth (404) instead of :3003/api/v1/auth
ENV VITE_DEV_API_URL=
# Vite + large deps (plotly, echarts, etc.) need more than default ~2GB heap
ENV NODE_OPTIONS=--max-old-space-size=8192

RUN npm run build

# Stage 2: serve with nginx
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html/tiei_dynamic
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
