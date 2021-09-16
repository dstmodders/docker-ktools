# docker-ktools

[![Debian Size](https://img.shields.io/docker/image-size/viktorpopkov/ktools/debian?label=debian%20size)](https://hub.docker.com/r/viktorpopkov/ktools)
[![Alpine Size](https://img.shields.io/docker/image-size/viktorpopkov/ktools/alpine?label=alpine%20size)](https://hub.docker.com/r/viktorpopkov/ktools)
[![CI](https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/CI?label=ci)](https://github.com/victorpopkov/docker-ktools/actions/workflows/ci.yml)

## Supported tags and respective `Dockerfile` links

_This repository uses a fork [victorpopkov/ktools][] instead of the original
[nsimplex/ktools][]. All tags prefixed with "official" point to
[official releases][]. See [fork releases][] to learn more._

- [`4.5.1-imagemagick-7.1.0-7-alpine`, `4.5.1`, `alpine`, `latest`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/latest/alpine/Dockerfile)
- [`4.5.1-imagemagick-7.1.0-7-debian`, `debian`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/latest/debian/Dockerfile)
- [`4.5.0-imagemagick-7.1.0-7-alpine`, `4.5.0`, `alpine`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/latest/alpine/Dockerfile)
- [`4.5.0-imagemagick-7.1.0-7-debian`, `debian`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/latest/debian/Dockerfile)
- [`4.5.0-imagemagick-7.1.0-5-alpine`](https://github.com/victorpopkov/docker-ktools/blob/ef2d40c3fc2e675ca492371e0e539f13449a1846/latest/alpine/Dockerfile)
- [`4.5.0-imagemagick-7.1.0-5-debian`](https://github.com/victorpopkov/docker-ktools/blob/ef2d40c3fc2e675ca492371e0e539f13449a1846/latest/debian/Dockerfile)
- [`4.4.1-imagemagick-6.9.12-19-alpine`, `4.4.1`, `alpine`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/latest/alpine/Dockerfile)
- [`4.4.1-imagemagick-6.9.12-19-debian`, `debian`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/latest/debian/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.12-19-alpine`, `official-4.4.0`, `official-alpine`, `official-latest`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/official/alpine/Dockerfile)
- [`official-4.4.0-imagemagick-6.9.12-19-debian`, `official-debian`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/official/debian/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.12-19-alpine`, `official-4.3.1`, `official-alpine`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/official/alpine/Dockerfile)
- [`official-4.3.1-imagemagick-6.9.12-19-debian`, `official-debian`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/official/debian/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.12-19-alpine`, `official-4.3.0`, `official-alpine`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/official/alpine/Dockerfile)
- [`official-4.3.0-imagemagick-6.9.12-19-debian`, `official-debian`](https://github.com/victorpopkov/docker-ktools/blob/48f361b4dcf1953b3d852902a47db00765bae0b4/official/debian/Dockerfile)

## Overview

[Docker][] images for modding tools of Klei Entertainment's game
[Don't Starve][].

- [Environment variables](#environment-variables)
- [Usage](#usage)
  - [Linux & macOS](#linux--macos)
  - [Windows](#windows)

## Environment variables

| Name                  | Value                  | Description             |
| --------------------- | ---------------------- | ----------------------- |
| `DS_KTOOLS_KRANE`     | `/usr/local/bin/krane` | Path to [krane][]       |
| `DS_KTOOLS_KTECH`     | `/usr/local/bin/ktech` | Path to [ktech][]       |
| `DS_KTOOLS_VERSION`   | `4.5.1`                | [ktools][] version      |
| `IMAGEMAGICK_VERSION` | `7.1.0-7`              | [ImageMagick][] version |

## Usage

[Fork releases][] (recommended):

```shell
$ docker pull viktorpopkov/ktools # same tag: 4.5.1-imagemagick-7.1.0-7-alpine
```

Or you can also pick one of the [official releases][]:

```shell
$ docker pull viktorpopkov/ktools:official # same tag: official-4.4.0-imagemagick-6.9.12-19-alpine
```

See [tags][] for a list of all available versions.

### Interactive

```shell
$ docker run --rm --user='ktools' --interactive --tty \
    --mount src='/path/to/your/data/',target='/data/',type=bind \
    viktorpopkov/ktools
```

The same, but shorter:

```shell
$ docker run --rm -u ktools -itv '/path/to/your/data/:/data/' viktorpopkov/ktools
```

### Non-interactive

```shell
$ docker run --rm --user='ktools' \
    --mount src='/path/to/your/data/',target='/data/',type=bind \
    viktorpopkov/ktools \
    ktech --version
```

The same, but shorter:

```shell
$ docker run --rm -u ktools -v '/path/to/your/data/:/data/' viktorpopkov/ktools ktech --version
```

### Linux & macOS

#### Shell/Bash

```shell
$ docker run --rm -u ktools -itv "$(pwd):/data/" viktorpopkov/ktools
```

### Windows

#### CMD

```cmd
> docker run --rm -u ktools -itv "%CD%:/data/" viktorpopkov/ktools
```

#### PowerShell

```powershell
PS:\> docker run --rm -u ktools -itv "${PWD}:/data/" viktorpopkov/ktools
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[@nsimplex]: https://github.com/nsimplex
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[fork releases]: https://github.com/victorpopkov/ktools/releases
[gcc]: https://gcc.gnu.org/
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
[latest state]: https://github.com/nsimplex/ktools/tree/a1d1362bdb2b9aa9146d7177fbf0e351eab414ba
[nsimplex/ktools]: https://github.com/nsimplex/ktools
[official releases]: https://github.com/nsimplex/ktools/releases
[official]: https://github.com/nsimplex/ktools/releases
[tags]: https://hub.docker.com/r/viktorpopkov/ktools/tags
[v4.4.0]: https://github.com/victorpopkov/ktools/releases/tag/4.4.0
[v4.4.1]: https://github.com/victorpopkov/ktools/releases/tag/v4.4.1
[victorpopkov/ktools]: https://github.com/victorpopkov/ktools
