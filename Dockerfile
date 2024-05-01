FROM alpine:3.19

ARG APP_VERSION=dev
ARG SPAMASSASSIN_VERSION=dev
ARG SPAMASSASSIN_LISTEN_PORT=783

LABEL org.opencontainers.image.title="spamassassin-docker"
LABEL org.opencontainers.image.description="Spamassassin in a Docker container."
LABEL org.opencontainers.image.authors="Pavel Kim <hello@pavelkim.com>"
LABEL org.opencontainers.image.url="https://github.com/reinvented-stuff/spamassassin-docker"
LABEL org.opencontainers.image.version="${APP_VERSION}"

RUN apk update && \
  apk add --no-cache \
    perl-dbi \
    perl-dbd-mysql \
    perl-dbd-pg \
    perl-dbd-sqlite \
    spamassassin=3.4.6-r7 \
    spamassassin-client=3.4.6-r7

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
