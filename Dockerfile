FROM ghcr.io/getzola/zola:v0.23.6 AS builder

WORKDIR /
COPY . .
RUN ["/zola", "build"]

FROM nginx:stable-alpine

COPY --from=builder /site/public/ /usr/share/nginx/html/

EXPOSE 80