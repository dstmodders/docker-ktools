FROM alpine:3.14.1

ARG DS_KTOOLS_VERSION="4.5.0"
ARG IMAGEMAGICK_VERSION="7.1.0-5"

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Install dependencies
RUN apk update \
  && apk add --no-cache \
    gcc='10.3.1_git20210424-r2' \
    libc-dev='0.7.2-r3' \
    libpng-dev='1.6.37-r1' \
    libzip-dev='1.7.3-r2' \
    readline-dev='8.1.0-r0' \
  && apk add --no-cache --virtual .build-deps \
    cmake='3.20.3-r0' \
    g++='10.3.1_git20210424-r2' \
    make='4.3-r0'

# Download and extract ImageMagick and ktools
RUN wget -P /tmp/ "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar xf "/tmp/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" -C /tmp/ \
  && wget -P /tmp/ "https://github.com/victorpopkov/ktools/archive/refs/tags/v${DS_KTOOLS_VERSION}.tar.gz" \
  && tar xzf "/tmp/v${DS_KTOOLS_VERSION}.tar.gz" -C /tmp/

# Build and install ImageMagick
WORKDIR /tmp/ImageMagick-${IMAGEMAGICK_VERSION}/
RUN ./configure \
  && make \
  && make install \
  && ldconfig /usr/local/lib/

# Install ktools
WORKDIR /tmp/ktools-${DS_KTOOLS_VERSION}/
RUN cmake \
    -DImageMagick_Magick++_LIBRARY="$(pkg-config --variable=libdir Magick++)/lib$(pkg-config --variable=libname Magick++).so" \
    -DImageMagick_MagickCore_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickCore | tail -c+3)" \
    -DImageMagick_MagickCore_LIBRARY="$(pkg-config --variable=libdir MagickCore)/lib$(pkg-config --variable=libname MagickCore).so" \
    -DImageMagick_MagickWand_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickWand | tail -c+3)" \
    -DImageMagick_MagickWand_LIBRARY="$(pkg-config --variable=libdir MagickWand)/lib$(pkg-config --variable=libname MagickWand).so" \
    . \
  && ./configure \
  && make \
  && make install

# Remove dependencies and temporary files
RUN apk del .build-deps \
  && rm -Rf /tmp/*

WORKDIR /data/
