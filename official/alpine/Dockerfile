ARG IMAGEMAGICK_IMAGE_PREFIX="legacy-"
ARG IMAGEMAGICK_VERSION="6.9.13-6"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG DS_KTOOLS_VERSION="4.4.0"
ENV DS_KTOOLS_VERSION="${DS_KTOOLS_VERSION}"

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/imagemagick/ktools/g' /etc/passwd /etc/group \
  && apk add --no-cache --virtual .ktools-deps \
    cmake='3.27.8-r0' \
    g++='13.2.1_git20231014-r0' \
    libc-dev='0.7.2-r5' \
    make='4.4.1-r2' \
    patch='2.7.6-r10' \
    readline-dev='8.2.1-r2' \
  # ktools
  && wget -q "https://github.com/nsimplex/ktools/archive/refs/tags/${DS_KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./${DS_KTOOLS_VERSION}.tar.gz" \
  && wget -q https://github.com/dstmodders/ktools/commit/47f38381671e03455eab193a1d3a88e11666af99.patch \
  && cd "/tmp/ktools-${DS_KTOOLS_VERSION}/" \
  && patch -p1 < /tmp/47f38381671e03455eab193a1d3a88e11666af99.patch \
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

USER ktools
WORKDIR /data/
