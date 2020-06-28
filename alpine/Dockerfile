FROM alpine:3.12.0

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV KTOOLS_VERSION="4.4.0"

# Install dependencies
RUN apk update \
  && apk add --no-cache \
    libc-dev \
    libpng-dev \
    libzip-dev \
    readline-dev \
  && apk add --no-cache --virtual .build-deps \
    ca-certificates \
    cmake \
    g++ \
    gcc \
    git \
    make \
    wget

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
    -DImageMagick_Magick++_LIBRARY="/usr/local/lib/libMagick++-6.Q16.so" \
    -DImageMagick_MagickCore_INCLUDE_DIR="/usr/local/include/ImageMagick-6" \
    -DImageMagick_MagickCore_LIBRARY="/usr/local/lib/libMagickCore-6.Q16.so" \
    -DImageMagick_MagickWand_INCLUDE_DIR="/usr/local/include/ImageMagick-6" \
    -DImageMagick_MagickWand_LIBRARY="/usr/local/lib/libMagickWand-6.Q16.so" \
   . \
  && ./configure \
  && make \
  && make install \
  && cd /tmp/ \
  && rm -Rf ktools* \
  && rm -Rf ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz ImageMagick-${IMAGEMAGICK_VERSION}*

# Remove dependencies
RUN apk del .build-deps
