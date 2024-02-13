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

- [`4.5.1-imagemagick-7.1.1-28-alpine`, `4.5.1`, `alpine`, `latest`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/latest/alpine/Dockerfile)
- [`4.5.1-imagemagick-7.1.1-28-debian`, `debian`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/latest/debian/Dockerfile)
- [`4.5.0-imagemagick-7.1.1-28-alpine`, `4.5.0`, `alpine`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/latest/alpine/Dockerfile)
- [`4.5.0-imagemagick-7.1.1-28-debian`, `debian`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/latest/debian/Dockerfile)
- [`4.5.0-imagemagick-7.1.0-5-alpine`](https://github.com/dstmodders/docker-ktools/blob/ef2d40c3fc2e675ca492371e0e539f13449a1846/latest/alpine/Dockerfile)
- [`4.5.0-imagemagick-7.1.0-5-debian`](https://github.com/dstmodders/docker-ktools/blob/ef2d40c3fc2e675ca492371e0e539f13449a1846/latest/debian/Dockerfile)
- [`4.4.1-imagemagick-6.9.13-6-alpine`, `4.4.1`, `alpine`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/latest/alpine/Dockerfile)
- [`4.4.1-imagemagick-6.9.13-6-debian`, `debian`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/latest/debian/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.13-6-alpine`, `official-4.4.0`, `official-alpine`, `official-latest`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/official/alpine/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.13-6-debian`, `official-debian`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/official/debian/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.13-6-alpine`, `official-4.3.1`, `official-alpine`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/official/alpine/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.13-6-debian`, `official-debian`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/official/debian/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.13-6-alpine`, `official-4.3.0`, `official-alpine`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/official/alpine/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.13-6-debian`, `official-debian`](https://github.com/dstmodders/docker-ktools/blob/ac1d087218af7d132c4427740648acf65df82453/official/debian/Dockerfile)

## Overview

[Docker] images for modding tools of Klei Entertainment's game
[Don't Starve].

- [Environment variables](#environment-variables)
- [Usage](#usage)
- [Build](#build)

## Environment variables

| Name                  | Value                  | Description           |
| --------------------- | ---------------------- | --------------------- |
| `DS_KTOOLS_KRANE`     | `/usr/local/bin/krane` | Path to [krane]       |
| `DS_KTOOLS_KTECH`     | `/usr/local/bin/ktech` | Path to [ktech]       |
| `DS_KTOOLS_VERSION`   | `4.5.1`                | [ktools] version      |
| `IMAGEMAGICK_VERSION` | `7.1.1-28`             | [ImageMagick] version |

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

## Build

To build images locally:

```shell
$ docker build ./latest/alpine/ --tag='dstmodders/ktools:alpine'
$ docker build ./latest/debian/ --tag='dstmodders/ktools:debian'
$ docker build ./official/alpine/ --tag='dstmodders/ktools:official-alpine'
$ docker build ./official/debian/ --tag='dstmodders/ktools:official-debian'
```

To build images locally using [buildx] to target multiple platforms, ensure that
your builder is running. If you are using [QEMU] emulation, you may also need to
enable [qemu-user-static].

In overall, to create your builder and enable [QEMU] emulation:

```shell
$ docker buildx create --name mybuilder --use --bootstrap
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Respectively, to build multi-platform images locally:

```shell
$ docker buildx build ./latest/alpine/ --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:alpine'
$ docker buildx build ./latest/debian/ --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:debian'
$ docker buildx build ./official/alpine/ --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:official-alpine'
$ docker buildx build ./official/debian/ --platform='linux/amd64,linux/386' --tag='dstmodders/ktools:official-debian'
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[@nsimplex]: https://github.com/nsimplex
[alpine size]: https://img.shields.io/docker/image-size/dstmodders/ktools/alpine?label=alpine%20size&logo=docker
[build]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-ktools/build.yml?branch=main&label=build&logo=github
[buildx]: https://github.com/docker/buildx
[ci]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-ktools/ci.yml?branch=main&label=ci&logo=github
[debian size]: https://img.shields.io/docker/image-size/dstmodders/ktools/debian?label=debian%20size&logo=docker
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[dstmodders/ktools]: https://github.com/dstmodders/ktools
[fork releases]: https://github.com/dstmodders/ktools/releases
[gcc]: https://gcc.gnu.org/
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
[latest state]: https://github.com/nsimplex/ktools/tree/a1d1362bdb2b9aa9146d7177fbf0e351eab414ba
[nsimplex/ktools]: https://github.com/nsimplex/ktools
[official releases]: https://github.com/nsimplex/ktools/releases
[official]: https://github.com/nsimplex/ktools/releases
[qemu-user-static]: https://github.com/multiarch/qemu-user-static
[qemu]: https://www.qemu.org/
[tags]: https://hub.docker.com/r/dstmodders/ktools/tags
[v4.4.0]: https://github.com/dstmodders/ktools/releases/tag/4.4.0
[v4.4.1]: https://github.com/dstmodders/ktools/releases/tag/v4.4.1
