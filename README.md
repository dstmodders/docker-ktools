# docker-ktools

[![Debian Size](https://img.shields.io/docker/image-size/viktorpopkov/ktools/debian?label=debian%20size)](https://hub.docker.com/r/viktorpopkov/ktools)
[![Alpine Size](https://img.shields.io/docker/image-size/viktorpopkov/ktools/alpine?label=alpine%20size)](https://hub.docker.com/r/viktorpopkov/ktools)
[![CI](https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/CI?label=CI)](https://github.com/victorpopkov/docker-ktools/actions/workflows/ci.yml)

> This repository uses a fork [victorpopkov/ktools][] instead of the original
> [nsimplex/ktools][]. All tags prefixed with "official" point to
> [official releases][]. See [releases][] and [tags][] to learn more.

## Overview

[Docker][] images for modding tools of Klei Entertainment's game
[Don't Starve][].

- [Environment variables](#environment-variables)
- [Usage](#usage)
  - [Linux & macOS](#linux--macos)
  - [Windows](#windows)

## Environment variables

| Name                  | Value                  | Description                         |
| --------------------- | ---------------------- | ----------------------------------- |
| `DS_KTOOLS_KRANE`     | `/usr/local/bin/krane` | Absolute path to the [krane][] tool |
| `DS_KTOOLS_KTECH`     | `/usr/local/bin/ktech` | Absolute path to the [ktech][] tool |
| `DS_KTOOLS_VERSION`   | `4.5.0`                | [ktools][] version                  |
| `IMAGEMAGICK_VERSION` | `7.1.0-5`              | [ImageMagick][] version             |

## Usage

Fork [releases][] (recommended):

```shell
$ docker pull viktorpopkov/ktools # same tag: 4.5.0-imagemagick-7.1.0-5-alpine
```

Or you can also pick one of the [official releases][]:

```shell
$ docker pull viktorpopkov/ktools:official # same tag: official-4.4.0-imagemagick-6.9.12-19-alpine
```

See [tags][] for all available versions.

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
[gcc]: https://gcc.gnu.org/
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
[latest state]: https://github.com/nsimplex/ktools/tree/a1d1362bdb2b9aa9146d7177fbf0e351eab414ba
[nsimplex/ktools]: https://github.com/nsimplex/ktools
[official releases]: https://github.com/nsimplex/ktools/releases
[official]: https://github.com/nsimplex/ktools/releases
[releases]: https://github.com/victorpopkov/ktools/releases
[tags]: https://hub.docker.com/r/viktorpopkov/ktools/tags
[v4.4.0]: https://github.com/victorpopkov/ktools/releases/tag/4.4.0
[v4.4.1]: https://github.com/victorpopkov/ktools/releases/tag/v4.4.1
[victorpopkov/ktools]: https://github.com/victorpopkov/ktools
