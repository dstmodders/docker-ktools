ARG IMAGEMAGICK_IMAGE_PREFIX=""
ARG IMAGEMAGICK_VERSION="7.1.1-45"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG KTOOLS_VERSION="4.5.1"
ENV KTOOLS_VERSION="${KTOOLS_VERSION}"

ENV KTOOLS_KRANE="/usr/local/bin/krane"
ENV KTOOLS_KTECH="/usr/local/bin/ktech"

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/imagemagick/ktools/g' /etc/passwd /etc/group \
  && apk add --no-cache --virtual .ktools-deps \
    build-base='0.5-r3' \
    cmake='3.31.7-r1' \
    g++='14.2.0-r6' \
    make='4.4.1-r3' \
    musl-dev='1.2.5-r10' \
    readline-dev='8.2.13-r1' \
  # ktools
  && wget -q "https://github.com/dstmodders/ktools/archive/refs/tags/v${KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./v${KTOOLS_VERSION}.tar.gz" \
  && cd "/tmp/ktools-${KTOOLS_VERSION}/" \
  && ./configure \
  && make \
  && make install \
  # clean
  && apk del .ktools-deps \
  && rm -rf /tmp/* \
  # smoke tests
  && which krane ktech \
  && krane --version \
  && ktech --version

USER ktools
WORKDIR /data/
