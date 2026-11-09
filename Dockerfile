FROM ghcr.io/getzola/zola:v0.23.6 AS builder

WORKDIR /dose
ADD https://github.com/gregorybfoulkes/dose.git#main .
RUN ["/zola", "build"]

FROM nginxinc/nginx-unprivileged:stable-alpine

COPY --from=builder /dose/public/ /usr/share/nginx/html/

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:8080/ || exit 1
