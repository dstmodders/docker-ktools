FROM alpine:3.12.0

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="4.4.0"
ENV IMAGEMAGICK_VERSION="6.9.11-3"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Install dependencies
RUN apk update \
  && apk add --no-cache \
    gcc=9.3.0-r2 \
    libc-dev=0.7.2-r3 \
    libpng-dev=1.6.37-r1 \
    libzip-dev=1.6.1-r1 \
    readline-dev=8.0.4-r0 \
  && apk add --no-cache --virtual .build-deps \
    ca-certificates=20191127-r4 \
    cmake=3.17.2-r0 \
    g++=9.3.0-r2 \
    git=2.26.2-r0 \
    make=4.3-r0 \
    wget=1.20.3-r1

# Download and extract ImageMagick and ktools
RUN wget -P /tmp/ "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar xf "/tmp/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" -C /tmp/ \
  # ktools
  && git clone https://github.com/victorpopkov/ktools.git /tmp/ktools/

# Build and install ImageMagick
WORKDIR /tmp/ImageMagick-${IMAGEMAGICK_VERSION}/
RUN ./configure \
  && make \
  && make install \
  && ldconfig /usr/local/lib/

# Install ktools
WORKDIR /tmp/ktools/
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
