FROM golang:1.11-alpine3.8

ARG caddy_revision
RUN apk add --no-cache git tar curl \
     && mkdir -p /go/src/github.com/mholt \
     && cd /go/src/github.com/mholt && git clone https://github.com/mholt/caddy

RUN cd /go/src/github.com/mholt/caddy && git checkout ${caddy_revision} -b deployment \
     && go get -u -d github.com/caddyserver/builds

WORKDIR /go/src/github.com/mholt/caddy

RUN wget https://github.com/oscartbeaumont/caddy/commit/248259b5b0808a827dd32bd102f6723791c3199b.patch -O oscartbeaumont.patch\
  && patch -p1 < oscartbeaumont.patch

WORKDIR /go/src/github.com/mholt/caddy/caddy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o caddy  && ./caddy -version
# /go/src/github.com/mholt/caddy/caddy/caddy

# custom config
#
FROM alpine:3.8

ARG caddy_revision
COPY --from=0 /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/caddy

RUN apk add --no-cache ca-certificates curl \
  && chmod 0755 /usr/bin/caddy \
  && /usr/bin/caddy -version \
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -G www-data www-data

ENV CADDYPATH=/config

RUN mkdir -p /config/tls && chown -R www-data:www-data /config \
    && /usr/bin/caddy -version

# VOLUME /config

ADD files/Caddyfile /config/Caddyfile

USER www-data
WORKDIR /config

ENTRYPOINT ["/usr/bin/caddy"]

CMD ["-ca", "https://acme-staging-v02.api.letsencrypt.org/directory", "-agree", "-http-port", "8080", "-https-port", "8443", "-conf", "/config/Caddyfile", "-log", "stdout"]
