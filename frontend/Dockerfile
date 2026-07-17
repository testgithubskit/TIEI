# Stage 1: build Vue app from current source
FROM node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
# Project has Vue2 peer deps (lucide-vue, element-ui) on a Vue3 app
RUN npm ci --legacy-peer-deps

COPY . .

# Production API goes through nginx /api → backend container
ENV VITE_API_URL=/api/v1
# Do not bake local DEV URL into production image
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
