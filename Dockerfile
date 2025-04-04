# Etap 1 - Budowanie aplikacji
FROM alpine AS builder
ARG VERSION="1.0.0"
RUN apk add --no-cache bash coreutils
COPY app.sh /app.sh
RUN chmod +x /app.sh

# Etap 2 - Serwer HTTP
FROM nginx:alpine

# Kopiowanie skryptu do kontenera
COPY --from=builder /app.sh /app.sh

# Ustawienie entrypoint, aby generować stronę HTML przy starcie kontenera
ENTRYPOINT ["/bin/sh", "-c", "/app.sh $VERSION && exec nginx -g 'daemon off;'"]

# HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=10s \
  CMD wget --spider -q http://localhost || exit 1
