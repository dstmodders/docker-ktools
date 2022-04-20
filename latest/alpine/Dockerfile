FROM alpine:3.15.4

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ARG IMAGEMAGICK_VERSION="7.1.0-29"
ENV IMAGEMAGICK_VERSION="${IMAGEMAGICK_VERSION}"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN addgroup -g 1000 ktools \
  && adduser -u 1000 -G ktools -s /bin/sh -D ktools \
  && apk add --no-cache \
    libgcc='10.3.1_git20211027-r0' \
    libgomp='10.3.1_git20211027-r0' \
    libpng-dev='1.6.37-r1' \
    libstdc++='10.3.1_git20211027-r0' \
    libzip-dev='1.8.0-r1' \
  && apk add --no-cache --virtual .imagemagick-deps \
    cmake='3.21.3-r0' \
    g++='10.3.1_git20211027-r0' \
    libc-dev='0.7.2-r3' \
    make='4.3-r0' \
  # ImageMagick
  && wget -q "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar -xf "./ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && cd "./ImageMagick-${IMAGEMAGICK_VERSION}/" \
  && ./configure --with-png \
  && make \
  && make install \
  && ldconfig /usr/local/lib/ \
  # clean
  && apk del .imagemagick-deps \
  && rm -Rf /tmp/* \
  # smoke test
  && identify -version

ARG DS_KTOOLS_VERSION="4.5.1"
ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="${DS_KTOOLS_VERSION}"

# Install ktools
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN apk add --no-cache --virtual .ktools-deps \
    cmake='3.21.3-r0' \
    g++='10.3.1_git20211027-r0' \
    libc-dev='0.7.2-r3' \
    make='4.3-r0' \
    readline-dev='8.1.1-r0' \
  # ktools
  && wget -q "https://github.com/victorpopkov/ktools/archive/refs/tags/v${DS_KTOOLS_VERSION}.tar.gz" \
  && tar -xzf "./v${DS_KTOOLS_VERSION}.tar.gz" \
  && cd "/tmp/ktools-${DS_KTOOLS_VERSION}/" \
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
  && apk del .ktools-deps \
  && rm -Rf /tmp/* \
  # smoke tests
  && which krane ktech \
  && krane --version \
  && ktech --version

WORKDIR /data/
