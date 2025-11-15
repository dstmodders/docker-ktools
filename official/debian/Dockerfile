ARG IMAGEMAGICK_IMAGE_PREFIX="legacy-"
ARG IMAGEMAGICK_VERSION="6.9.13-26"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-debian

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG KTOOLS_VERSION="4.4.0"
ENV KTOOLS_VERSION="${KTOOLS_VERSION}"

ARG TARGETPLATFORM
ENV KTOOLS_KRANE="/usr/local/bin/krane"
ENV KTOOLS_KTECH="/usr/local/bin/ktech"

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/imagemagick/ktools/g' /etc/passwd /etc/group \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.12' \
    ca-certificates='20250419' \
    cmake='3.31.6-2' \
    patch='2.8-2' \
    pkg-config='1.8.1-4' \
    wget='1.25.0-2' \
  # ktools
  && wget -q "https://github.com/nsimplex/ktools/archive/refs/tags/${KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./${KTOOLS_VERSION}.tar.gz" \
  && wget -q https://github.com/dstmodders/ktools/commit/47f38381671e03455eab193a1d3a88e11666af99.patch \
  && cd "/tmp/ktools-${KTOOLS_VERSION}/" \
  && patch -p1 < /tmp/47f38381671e03455eab193a1d3a88e11666af99.patch \
  && ./configure \
  && make \
  && make install \
  # clean
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    cmake \
    patch \
    pkg-config \
    wget \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log \
  # smoke tests
  && which krane ktech \
  && krane --version \
  && ktech --version

USER ktools
WORKDIR /data/
