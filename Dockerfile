FROM bluenviron/mediamtx:latest AS mediamtx

FROM nginx:alpine

RUN apk add --no-cache ca-certificates

COPY --from=mediamtx /mediamtx /usr/local/bin/mediamtx
COPY mediamtx.yml /mediamtx.yml
COPY nginx.conf /etc/nginx/nginx.conf.template

ENV PORT=10000

EXPOSE 10000

CMD ["/bin/sh", "-c", "export PORT=${PORT:-10000} && envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && /usr/local/bin/mediamtx /mediamtx.yml & exec nginx -g 'daemon off;'"]
