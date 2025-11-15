## Supported tags and respective `Dockerfile` links

- [`4.5.1-imagemagick-7.1.2-0-alpine`, `4.5.1-alpine`, `4.5.1`, `alpine`, `latest`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/latest/alpine/Dockerfile)
- [`4.5.1-imagemagick-7.1.2-0-debian`, `4.5.1-debian`, `debian`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/latest/debian/Dockerfile)
- [`4.5.0-imagemagick-7.1.2-0-alpine`, `4.5.0-alpine`, `4.5.0`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/latest/alpine/Dockerfile)
- [`4.5.0-imagemagick-7.1.2-0-debian`, `4.5.0-debian`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/latest/debian/Dockerfile)
- [`4.4.1-imagemagick-6.9.13-26-alpine`, `4.4.1-alpine`, `4.4.1`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/latest/alpine/Dockerfile)
- [`4.4.1-imagemagick-6.9.13-26-debian`, `4.4.1-debian`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/latest/debian/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.13-26-alpine`, `official-4.4.0-alpine`, `official-4.4.0`, `official-alpine`, `official-latest`, `official`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/official/alpine/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.13-26-debian`, `official-4.4.0-debian`, `official-debian`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/official/debian/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.13-26-alpine`, `official-4.3.1-alpine`, `official-4.3.1`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/official/alpine/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.13-26-debian`, `official-4.3.1-debian`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/official/debian/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.13-26-alpine`, `official-4.3.0-alpine`, `official-4.3.0`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/official/alpine/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.13-26-debian`, `official-4.3.0-debian`](https://github.com/dstmodders/docker-ktools/blob/35fbda7cb2509b52cc15de654fe54e8401aa7c57/official/debian/Dockerfile)

## Overview

[Docker] images for modding tools of Klei Entertainment's game [Don't Starve].

- [Usage](https://github.com/dstmodders/docker-ktools/blob/main/README.md#usage)
- [Supported environment variables](https://github.com/dstmodders/docker-ktools/blob/main/README.md#supported-environment-variables)
- [Supported build arguments](https://github.com/dstmodders/docker-ktools/blob/main/README.md#supported-build-arguments)
- [Supported architectures](https://github.com/dstmodders/docker-ktools/blob/main/README.md#supported-architectures)
- [Build](https://github.com/dstmodders/docker-ktools/blob/main/README.md#build)

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
| `IMAGEMAGICK_VERSION` | `7.1.2-0`              | [ImageMagick] version |
| `KTOOLS_KRANE`        | `/usr/local/bin/krane` | [ktools/krane] path   |
| `KTOOLS_KTECH`        | `/usr/local/bin/ktech` | [ktools/ktech] path   |
| `KTOOLS_VERSION`      | `4.5.1`                | [ktools] version      |

## Supported build arguments

| Name                       | Image                    | Default                    | Description                          |
| -------------------------- | ------------------------ | -------------------------- | ------------------------------------ |
| `IMAGEMAGICK_IMAGE_PREFIX` | `latest`<br />`official` | -<br />`legacy-`           | Sets [ImageMagick] base image prefix |
| `IMAGEMAGICK_VERSION`      | `latest`<br />`official` | `7.1.2-0`<br />`6.9.13-27` | Sets [ImageMagick] version           |
| `KTOOLS_VERSION`           | `latest`<br />`official` | `4.5.1`<br />`4.4.0`       | Sets [ktools] version                |

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

[buildx]: https://github.com/docker/buildx
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[fork releases]: https://github.com/dstmodders/ktools/releases
[imagemagick]: https://imagemagick.org/index.php
[ktools/krane]: https://github.com/dstmodders/ktools?tab=readme-ov-file#krane
[ktools/ktech]: https://github.com/dstmodders/ktools?tab=readme-ov-file#ktech
[ktools]: https://github.com/dstmodders/ktools
[official releases]: https://github.com/nsimplex/ktools/releases
[tags]: https://hub.docker.com/r/dstmodders/ktools/tags
