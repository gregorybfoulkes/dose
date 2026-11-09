FROM ghcr.io/getzola/zola:v0.23.6 AS builder

WORKDIR /site
ADD https://github.com/gregorybfoulkes/dose.git#main .
RUN ["/zola", "build"]

FROM nginx:stable-alpine

COPY --from=builder /site/public/ /usr/share/nginx/html/

EXPOSE 80