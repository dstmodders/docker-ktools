FROM debian:bullseye

ARG DS_KTOOLS_VERSION="4.4.0"
ARG IMAGEMAGICK_VERSION="6.9.12-19"

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20210119' \
    cmake='3.18.4-2' \
    git='1:2.30.2-1' \
    libpng-dev='1.6.37-3' \
    libreadline-dev='8.1-1' \
    libzip-dev='1.7.3-1' \
    patch='2.7.6-7' \
    pkg-config='0.29.2-1' \
    wget='1.21-1+b1' \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

# Download and extract ImageMagick and ktools
RUN wget -P /tmp/ "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar xf "/tmp/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" -C /tmp/ \
  && wget -P /tmp/ "https://github.com/victorpopkov/ktools/archive/refs/tags/${DS_KTOOLS_VERSION}.tar.gz" \
  && tar xzf "/tmp/${DS_KTOOLS_VERSION}.tar.gz" -C /tmp/

# Build and install ImageMagick
WORKDIR /tmp/ImageMagick-${IMAGEMAGICK_VERSION}/
RUN ./configure \
  && make \
  && make install \
  && ldconfig /usr/local/lib/

# Install ktools
WORKDIR /tmp/ktools-${DS_KTOOLS_VERSION}/
RUN wget -P /tmp/ 'https://github.com/victorpopkov/ktools/commit/47f38381671e03455eab193a1d3a88e11666af99.patch' \
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
  && make install

# Remove dependencies
RUN apt-get remove -y \
    build-essential \
    ca-certificates \
    cmake \
    git \
    patch \
    pkg-config \
    wget \
  && rm -Rf /tmp/*

WORKDIR /data/
