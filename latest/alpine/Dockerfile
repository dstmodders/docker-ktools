FROM alpine:3.17.3

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG IMAGEMAGICK_VERSION="7.1.1-6"
ENV IMAGEMAGICK_VERSION="${IMAGEMAGICK_VERSION}"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN addgroup -g 1000 ktools \
  && adduser -u 1000 -G ktools -s /bin/sh -D ktools \
  && apk add --no-cache \
    libgcc='12.2.1_git20220924-r4' \
    libgomp='12.2.1_git20220924-r4' \
    libpng-dev='1.6.38-r0' \
    libstdc++='12.2.1_git20220924-r4' \
    libzip-dev='1.9.2-r2' \
  && apk add --no-cache --virtual .imagemagick-deps \
    cmake='3.24.4-r0' \
    g++='12.2.1_git20220924-r4' \
    git='2.38.4-r1' \
    libc-dev='0.7.2-r3' \
    make='4.3-r1' \
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
ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="${DS_KTOOLS_VERSION}"

# Install ktools
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN apk add --no-cache --virtual .ktools-deps \
    cmake='3.24.4-r0' \
    g++='12.2.1_git20220924-r4' \
    libc-dev='0.7.2-r3' \
    make='4.3-r1' \
    readline-dev='8.2.0-r0' \
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
