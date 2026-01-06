# =========================
# 1️⃣ Build stage
# =========================
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build


# =========================
# 2️⃣ Distroless runtime
# =========================
FROM gcr.io/distroless/nodejs20-debian12

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 5173

# ⚠️ NO "node" here
CMD ["node_modules/vite/bin/vite.js", "preview", "--host", "0.0.0.0", "--port", "5173"]
