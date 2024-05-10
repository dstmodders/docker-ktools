ARG IMAGEMAGICK_IMAGE_PREFIX=""
ARG IMAGEMAGICK_VERSION="7.1.1-32"

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
    cmake='3.27.8-r0' \
    g++='13.2.1_git20231014-r0' \
    libc-dev='0.7.2-r5' \
    make='4.4.1-r2' \
    readline-dev='8.2.1-r2' \
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
