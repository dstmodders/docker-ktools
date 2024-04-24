# docker-ktools

[![Debian Size]](https://hub.docker.com/r/dstmodders/ktools)
[![Alpine Size]](https://hub.docker.com/r/dstmodders/ktools)
[![CI]](https://github.com/dstmodders/docker-ktools/actions/workflows/ci.yml)
[![Build]](https://github.com/dstmodders/docker-ktools/actions/workflows/build.yml)

> [!NOTE]
> This repository uses a fork [dstmodders/ktools] instead of the original
> [nsimplex/ktools]. All tags prefixed with "official" point to
> [official releases]. See [fork releases] to learn more.

## Supported tags and respective `Dockerfile` links

- [`4.5.1-imagemagick-7.1.1-30-alpine`, `4.5.1-alpine`, `4.5.1`, `alpine`, `latest`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/latest/alpine/Dockerfile)
- [`4.5.1-imagemagick-7.1.1-30-debian`, `4.5.1-debian`, `debian`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/latest/debian/Dockerfile)
- [`4.5.0-imagemagick-7.1.1-30-alpine`, `4.5.0-alpine`, `4.5.0`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/latest/alpine/Dockerfile)
- [`4.5.0-imagemagick-7.1.1-30-debian`, `4.5.0-debian`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/latest/debian/Dockerfile)
- [`4.4.1-imagemagick-6.9.13-8-alpine`, `4.4.1-alpine`, `4.4.1`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/latest/alpine/Dockerfile)
- [`4.4.1-imagemagick-6.9.13-8-debian`, `4.4.1-debian`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/latest/debian/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.13-8-alpine`, `official-4.4.0-alpine`, `official-4.4.0`, `official-alpine`, `official-latest`, `official`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/official/alpine/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.13-8-debian`, `official-4.4.0-debian`, `official-debian`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/official/debian/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.13-8-alpine`, `official-4.3.1-alpine`, `official-4.3.1`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/official/alpine/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.13-8-debian`, `official-4.3.1-debian`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/official/debian/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.13-8-alpine`, `official-4.3.0-alpine`, `official-4.3.0`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/official/alpine/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.13-8-debian`, `official-4.3.0-debian`](https://github.com/dstmodders/docker-ktools/blob/5322a24f20139f6db66af1f25ab5ac7c73d4847c/official/debian/Dockerfile)

## Overview

[Docker] images for modding tools of Klei Entertainment's game [Don't Starve].

- [Usage](#usage)
- [Supported environment variables](#supported-environment-variables)
- [Supported build arguments](#supported-build-arguments)
- [Supported architectures](#supported-architectures)
- [Build](#build)

## Usage

[Fork releases] (recommended):

```shell
$ docker pull dstmodders/ktools:latest
# or
$ docker pull ghcr.io/dstmodders/ktools:latest
```

Or you can pick one of the [official releases]:

```shell
$ docker pull dstmodders/ktools:official
# or
$ docker pull ghcr.io/dstmodders/ktools:official
```

See [tags] for a list of all available versions.

#### Shell/Bash (Linux & macOS)

```shell
$ docker run --rm -v "$(pwd):/data/" dstmodders/ktools ktech --version
```

#### CMD (Windows)

```cmd
> docker run --rm -v "%CD%:/data/" dstmodders/ktools ktech --version
```

#### PowerShell (Windows)

```powershell
PS:\> docker run --rm -v "${PWD}:/data/" dstmodders/ktools ktech --version
```

## Supported environment variables

| Name                  | Value                  | Description           |
| --------------------- | ---------------------- | --------------------- |
| `DS_KTOOLS_KRANE`     | `/usr/local/bin/krane` | [krane] path          |
| `DS_KTOOLS_KTECH`     | `/usr/local/bin/ktech` | [ktech] path          |
| `DS_KTOOLS_VERSION`   | `4.5.1`                | [ktools] version      |
| `IMAGEMAGICK_VERSION` | `7.1.1-30`             | [ImageMagick] version |

## Supported build arguments

| Name                       | Image                    | Default                    | Description                          |
| -------------------------- | ------------------------ | -------------------------- | ------------------------------------ |
| `DS_KTOOLS_VERSION`        | `latest`<br />`official` | `4.5.1`<br />`4.4.0`       | Sets [ktools] version                |
| `IMAGEMAGICK_IMAGE_PREFIX` | `latest`<br />`official` | -<br />`legacy-`           | Sets [ImageMagick] base image prefix |
| `IMAGEMAGICK_VERSION`      | `latest`<br />`official` | `7.1.1-30`<br />`6.9.13-8` | Sets [ImageMagick] version           |

## Supported architectures

| Image      | Architecture(s)            |
| ---------- | -------------------------- |
| `latest`   | `linux/amd64`, `linux/386` |
| `official` | `linux/amd64`, `linux/386` |

## Build

To build images locally:

```shell
$ docker build --tag='dstmodders/ktools:alpine' ./latest/alpine/
$ docker build --tag='dstmodders/ktools:debian' ./latest/debian/
$ docker build --tag='dstmodders/ktools:official-alpine' ./official/alpine/
$ docker build --tag='dstmodders/ktools:official-debian' ./official/debian/
```

Respectively, to build multi-platform images using [buildx]:

```shell
$ docker buildx build --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:alpine' ./latest/alpine/
$ docker buildx build --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:debian' ./latest/debian/
$ docker buildx build --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:official-alpine' ./official/alpine/
$ docker buildx build --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:official-debian' ./official/debian/
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[alpine size]: https://img.shields.io/docker/image-size/dstmodders/ktools/alpine?label=alpine%20size&logo=docker
[build]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-ktools/build.yml?branch=main&label=build&logo=github
[buildx]: https://github.com/docker/buildx
[ci]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-ktools/ci.yml?branch=main&label=ci&logo=github
[debian size]: https://img.shields.io/docker/image-size/dstmodders/ktools/debian?label=debian%20size&logo=docker
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[dstmodders/ktools]: https://github.com/dstmodders/ktools
[fork releases]: https://github.com/dstmodders/ktools/releases
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
[nsimplex/ktools]: https://github.com/nsimplex/ktools
[official releases]: https://github.com/nsimplex/ktools/releases
[tags]: https://hub.docker.com/r/dstmodders/ktools/tags
