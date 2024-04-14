ARG IMAGEMAGICK_IMAGE_PREFIX="legacy-"
ARG IMAGEMAGICK_VERSION="6.9.13-8"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-debian

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG DS_KTOOLS_VERSION="4.4.0"
ENV DS_KTOOLS_VERSION="${DS_KTOOLS_VERSION}"

ARG TARGETPLATFORM
ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/imagemagick/ktools/g' /etc/passwd /etc/group \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20230311' \
    cmake='3.25.1-1' \
    patch='2.7.6-7' \
    pkg-config='1.8.1-1' \
    wget="$([[ "${TARGETPLATFORM}" == 'linux/386' ]] && echo '1.21.3-1+b1' || echo '1.21.3-1+b2')" \
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
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    cmake \
    patch \
    pkg-config \
    wget \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf /var/lib/apt/lists/* \
  && rm -Rf \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log \
  # smoke tests
  && which krane ktech \
  && krane --version \
  && ktech --version

USER ktools
WORKDIR /data/
