ARG IMAGEMAGICK_IMAGE_PREFIX=""
ARG IMAGEMAGICK_VERSION="7.1.2-12"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG BUILD_CPUS
ARG KTOOLS_VERSION="4.5.1"
ENV KTOOLS_VERSION="${KTOOLS_VERSION}"

ENV KTOOLS_KRANE="/usr/local/bin/krane"
ENV KTOOLS_KTECH="/usr/local/bin/ktech"

# hadolint ignore=DL3066
USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/imagemagick/ktools/g' /etc/passwd /etc/group \
  && apk add --no-cache --virtual .ktools-deps \
    build-base='0.5-r4' \
    cmake='4.2.3-r0' \
    g++='15.2.0-r5' \
    make='4.4.1-r4' \
    musl-dev='1.2.6-r2' \
    readline-dev='8.3.3-r1' \
  # ktools
  && wget -q "https://github.com/dstmodders/ktools/archive/refs/tags/v${KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./v${KTOOLS_VERSION}.tar.gz" \
  && cd "/tmp/ktools-${KTOOLS_VERSION}/" \
  && sed -i 's/exec cmake -DCMAKE_BUILD_TYPE=Release ./exec cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ./g' configure \
  && ./configure \
  && : "${BUILD_CPUS:=$(($(nproc) > 1 ? $(nproc) / 2 : 1))}" \
  && echo "BUILD_CPUS=${BUILD_CPUS}" \
  && echo "make -j${BUILD_CPUS}" \
  && make -j"${BUILD_CPUS}" \
  && make install \
  # clean
  && apk del .ktools-deps \
  && rm -rf /tmp/* \
  # smoke tests
  && which krane ktech \
  && krane --version \
  && ktech --version

USER 1000:1000
WORKDIR /data/
