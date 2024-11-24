ARG IMAGEMAGICK_IMAGE_PREFIX=""
ARG IMAGEMAGICK_VERSION="7.1.1-41"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-debian

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG KTOOLS_VERSION="4.5.1"
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
    build-essential='12.9' \
    ca-certificates='20230311' \
    cmake='3.25.1-1' \
    pkg-config='1.8.1-1' \
    wget="$([[ "${TARGETPLATFORM}" == 'linux/386' ]] && echo '1.21.3-1+b1' || echo '1.21.3-1+b2')" \
  # ktools
  && wget -q "https://github.com/dstmodders/ktools/archive/refs/tags/v${KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./v${KTOOLS_VERSION}.tar.gz" \
  && cd "/tmp/ktools-${KTOOLS_VERSION}/" \
  && ./configure \
  && make \
  && make install \
  # clean
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    cmake \
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
