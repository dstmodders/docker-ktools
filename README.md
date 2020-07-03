# docker-ktools

[![Docker Image Debian Size]](https://hub.docker.com/r/viktorpopkov/ktools)
[![Docker Image Alpine Size]](https://hub.docker.com/r/viktorpopkov/ktools)
[![GitHub Workflow CI Status][]](https://github.com/victorpopkov/docker-ktools/actions?query=workflow%3ACI)
[![GitHub Workflow Publish Status][]](https://github.com/victorpopkov/docker-ktools/actions?query=workflow%3APublish)

## Overview

The [Docker][] images for the [ktools][] created by [@nsimplex][].

This repository uses a forked version ([victorpopkov/ktools][]) which includes
the [#13](https://github.com/nsimplex/ktools/pull/13) fix, so that it could be
compiled on a more recent [GCC][].

## Usage

```shell script
$ cd <your mod directory>
$ docker pull viktorpopkov/ktools
```

### Interactive Shell

```shell script
$ docker run --rm --interactive --tty \
    --mount src='<your mod directory>',target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
```

### Non-interactive Shell

```shell script
$ docker run --rm \
    --mount src='<your mod directory>',target='/data/',type=bind \
    --workdir='/mod/' \
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

```shell script
$ docker run --rm -itv "%CD%:/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```shell script
$ docker run --rm -v "%CD%:/data/" viktorpopkov/ktools ktech --version
```

#### PowerShell

##### Interactive Shell

```shell script
$ docker run --rm -itv "${PWD}:/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```shell script
$ docker run --rm -v "${PWD}:/data/" viktorpopkov/ktools ktech --version
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[@nsimplex]: https://github.com/nsimplex
[docker image alpine size]: https://img.shields.io/docker/image-size/viktorpopkov/ktools/debian?label=debian%20size
[docker image debian size]: https://img.shields.io/docker/image-size/viktorpopkov/ktools/alpine?label=alpine%20size
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[gcc]: https://gcc.gnu.org/
[github workflow ci status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/CI?label=CI
[github workflow publish status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/Publish?label=Publish
[ktools]: https://github.com/nsimplex/ktools
[victorpopkov/ktools]: https://github.com/victorpopkov/ktools
