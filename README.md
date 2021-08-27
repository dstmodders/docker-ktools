# docker-ktools

[![Debian Size](https://img.shields.io/docker/image-size/viktorpopkov/ktools/debian?label=debian%20size)](https://hub.docker.com/r/viktorpopkov/ktools)
[![Alpine Size](https://img.shields.io/docker/image-size/viktorpopkov/ktools/alpine?label=alpine%20size)](https://hub.docker.com/r/viktorpopkov/ktools)
[![CI](https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/CI?label=CI)](https://github.com/victorpopkov/docker-ktools/actions/workflows/ci.yml)

## Overview

The [Docker][] images for the [ktools][] created by [@nsimplex][].

This repository uses a fork [victorpopkov/ktools][] as the original
one does seem to be abandoned (the last commit was in 2016).

- [Environment variables](#environment-variables)
- [Usage](#usage)
  - [Linux](#linux)
  - [Windows](#windows)

## Environment variables

| Name                  | Value                  | Description                         |
| --------------------- | ---------------------- | ----------------------------------- |
| `DS_KTOOLS_KRANE`     | `/usr/local/bin/krane` | Absolute path to the [krane][] tool |
| `DS_KTOOLS_KTECH`     | `/usr/local/bin/ktech` | Absolute path to the [ktech][] tool |
| `DS_KTOOLS_VERSION`   | `4.5.0`                | [ktools][] version                  |
| `IMAGEMAGICK_VERSION` | `7.1.0-5`              | [ImageMagick][] version             |

## Usage

```shell script
$ cd <your data directory>
$ docker pull viktorpopkov/ktools
```

### Interactive Shell

```shell script
$ docker run --rm --interactive --tty \
    --mount src='<your data directory>',target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
```

### Non-interactive Shell

```shell script
$ docker run --rm \
    --mount src='<your data directory>',target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools \
    ktech --version
```

### Linux

#### Bash

##### Interactive Shell

```shell script
$ docker run --rm --interactive --tty \
    --mount src="$(pwd)",target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
# or
$ docker run --rm -itv "$(pwd):/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```shell script
$ docker run --rm -v "$(pwd):/data/" viktorpopkov/ktools ktech --version
```

### Windows

#### CMD

##### Interactive Shell

```cmd
> docker run --rm -itv "%CD%:/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```cmd
> docker run --rm -v "%CD%:/data/" viktorpopkov/ktools ktech --version
```

#### PowerShell

##### Interactive Shell

```powershell
PS:\> docker run --rm -itv "${PWD}:/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```powershell
PS:\> docker run --rm -v "${PWD}:/data/" viktorpopkov/ktools ktech --version
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
[victorpopkov/ktools]: https://github.com/victorpopkov/ktools
