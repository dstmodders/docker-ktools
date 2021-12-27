FROM debian:bullseye-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG IMAGEMAGICK_VERSION="6.9.12-34"
ENV IMAGEMAGICK_VERSION="${IMAGEMAGICK_VERSION}"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN groupadd --gid 1000 ktools \
  && useradd --uid 1000 --gid ktools --shell /bin/bash --create-home ktools \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20210119' \
    libgomp1='10.2.1-6' \
    libpng-dev='1.6.37-3' \
    libzip-dev='1.7.3-1' \
    pkg-config='0.29.2-1' \
    wget='1.21-1+deb11u1' \
  # ImageMagick
  && wget "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar -xf "./ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && cd "./ImageMagick-${IMAGEMAGICK_VERSION}/" \
  && ./configure --with-png \
  && make \
  && make install \
  && ldconfig /usr/local/lib/ \
  # clean
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    pkg-config \
    wget \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /etc/wgetrc \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log \
  # smoke test
  && identify -version

ARG DS_KTOOLS_VERSION="4.4.0"
ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="${DS_KTOOLS_VERSION}"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20210119' \
    cmake='3.18.4-2+deb11u1' \
    patch='2.7.6-7' \
    pkg-config='0.29.2-1' \
    wget='1.21-1+deb11u1' \
  # ktools
  && wget "https://github.com/nsimplex/ktools/archive/refs/tags/${DS_KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./${DS_KTOOLS_VERSION}.tar.gz" \
  && wget https://github.com/victorpopkov/ktools/commit/47f38381671e03455eab193a1d3a88e11666af99.patch \
  && cd "/tmp/ktools-${DS_KTOOLS_VERSION}/" \
  && patch -p1 < /tmp/47f38381671e03455eab193a1d3a88e11666af99.patch \
  && cmake \
    -DImageMagick_Magick++_LIBRARY="$(pkg-config --variable=libdir Magick++)/lib$(pkg-config --variable=libname Magick++).so" \
    -DImageMagick_MagickCore_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickCore | tail -c+3)" \
    -DImageMagick_MagickCore_LIBRARY="$(pkg-config --variable=libdir MagickCore)/lib$(pkg-config --variable=libname MagickCore).so" \
    -DImageMagick_MagickWand_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickWand | tail -c+3)" \
    -DImageMagick_MagickWand_LIBRARY="$(pkg-config --variable=libdir MagickWand)/lib$(pkg-config --variable=libname MagickWand).so" \
    . \
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

WORKDIR /data/
