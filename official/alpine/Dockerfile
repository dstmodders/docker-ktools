ARG IMAGEMAGICK_IMAGE_PREFIX="legacy-"
ARG IMAGEMAGICK_VERSION="6.9.13-34"

FROM dstmodders/imagemagick:${IMAGEMAGICK_IMAGE_PREFIX}${IMAGEMAGICK_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG BUILD_CPUS
ARG KTOOLS_VERSION="4.4.0"
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
    patch='2.8-r0' \
    readline-dev='8.3.3-r1' \
  # ktools
  && wget -q "https://github.com/nsimplex/ktools/archive/refs/tags/${KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./${KTOOLS_VERSION}.tar.gz" \
  && wget -q https://github.com/dstmodders/ktools/commit/47f38381671e03455eab193a1d3a88e11666af99.patch \
  && cd "/tmp/ktools-${KTOOLS_VERSION}/" \
  && patch -p1 < /tmp/47f38381671e03455eab193a1d3a88e11666af99.patch \
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
