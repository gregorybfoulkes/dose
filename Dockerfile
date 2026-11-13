ARG ZOLA_IMAGE=ghcr.io/getzola/zola:v0.23.6
ARG NGINX_IMAGE=nginxinc/nginx-unprivileged:stable-alpine

FROM ${ZOLA_IMAGE} AS builder

ARG SITE_REPOSITORY=https://github.com/gregorybfoulkes/dose.git
ARG SITE_REF=main

WORKDIR /src
ADD ${SITE_REPOSITORY}#${SITE_REF} .
RUN ["/zola", "build", "--output-dir", "/site"]

FROM ${NGINX_IMAGE} AS runtime

COPY --from=builder /site/ /usr/share/nginx/html/

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:8080/ || exit 1
