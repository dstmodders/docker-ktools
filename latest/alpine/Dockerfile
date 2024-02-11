FROM alpine:3.19.1

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG IMAGEMAGICK_VERSION="7.1.1-28"
ENV IMAGEMAGICK_VERSION="${IMAGEMAGICK_VERSION}"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN addgroup -g 1000 ktools \
  && adduser -u 1000 -G ktools -s /bin/sh -D ktools \
  && apk add --no-cache \
    libgcc='13.2.1_git20231014-r0' \
    libgomp='13.2.1_git20231014-r0' \
    libpng-dev='1.6.40-r0' \
    libstdc++='13.2.1_git20231014-r0' \
    libzip-dev='1.10.1-r0' \
  && apk add --no-cache --virtual .imagemagick-deps \
    cmake='3.27.8-r0' \
    g++='13.2.1_git20231014-r0' \
    git='2.43.0-r0' \
    libc-dev='0.7.2-r5' \
    make='4.4.1-r2' \
  # ImageMagick
  && git clone "https://github.com/ImageMagick/ImageMagick$([ "$(printf '%s' "${IMAGEMAGICK_VERSION}" | cut -c 1)" -eq '6' ] && echo '6').git" /tmp/ImageMagick/ \
  && cd "/tmp/ImageMagick/" \
  && git checkout "${IMAGEMAGICK_VERSION}" \
  && ./configure --with-png \
  && make \
  && make install \
  && ldconfig /usr/local/lib/ \
  # clean
  && apk del .imagemagick-deps \
  && rm -Rf /tmp/* \
  # smoke test
  && identify -version

ARG DS_KTOOLS_VERSION="4.5.1"
ENV DS_KTOOLS_VERSION="${DS_KTOOLS_VERSION}"

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"

# Install ktools
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN apk add --no-cache --virtual .ktools-deps \
    cmake='3.27.8-r0' \
    g++='13.2.1_git20231014-r0' \
    libc-dev='0.7.2-r5' \
    make='4.4.1-r2' \
    readline-dev='8.2.1-r2' \
  # ktools
  && wget -q "https://github.com/dstmodders/ktools/archive/refs/tags/v${DS_KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./v${DS_KTOOLS_VERSION}.tar.gz" \
  && cd "/tmp/ktools-${DS_KTOOLS_VERSION}/" \
  && ./configure \
  && make \
  && make install \
  # clean
  && apk del .ktools-deps \
  && rm -Rf /tmp/* \
  # smoke tests
  && which krane ktech \
  && krane --version \
  && ktech --version

WORKDIR /data/
