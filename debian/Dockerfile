FROM debian:bullseye

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="4.4.0"
ENV IMAGEMAGICK_VERSION="6.9.11-3"

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
    pkg-config='0.29.2-1' \
    wget='1.21-1+b1' \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

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

# Remove dependencies
RUN apt-get remove -y \
    build-essential \
    ca-certificates \
    cmake \
    git \
    pkg-config \
    wget \
  && rm -Rf /tmp/*

WORKDIR /data/
