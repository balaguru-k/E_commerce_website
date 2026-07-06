# Build stage
FROM node:18-alpine AS build

WORKDIR /app

# Copy package manifest(s) and install dependencies
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps

# Copy source and build
COPY . .
RUN npm run build

# Production stage
FROM nginx:stable-alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built app
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]