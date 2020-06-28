FROM debian:buster

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV KTOOLS_VERSION="4.4.0"

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libpng-dev \
    libreadline-dev \
    libzip-dev \
    pkg-config \
    wget \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

# Install ImageMagick and ktools
RUN cd /tmp/ \
  && wget "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar xf "ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && cd "ImageMagick-${IMAGEMAGICK_VERSION}" \
  && ./configure \
  && make \
  && make install \
  && ldconfig /usr/local/lib \
  && cd /tmp/ \
  && git clone https://github.com/victorpopkov/ktools.git \
  && cd ktools \
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
  && cd /tmp/ \
  && rm -Rf ktools* \
  && rm -Rf ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz ImageMagick-${IMAGEMAGICK_VERSION}*

# Remove dependencies
RUN apt-get remove -y \
  build-essential \
  ca-certificates \
  cmake \
  git \
  pkg-config \
  wget
