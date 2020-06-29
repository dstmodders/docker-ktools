# docker-ktools

[![Docker Image Debian Size]](https://hub.docker.com/r/viktorpopkov/ktools)
[![Docker Image Alpine Size]](https://hub.docker.com/r/viktorpopkov/ktools)
[![GitHub Workflow CI Status][]](https://github.com/victorpopkov/docker-ktools/actions?query=workflow%3ACI)
[![GitHub Workflow Publish Status][]](https://github.com/victorpopkov/docker-ktools/actions?query=workflow%3APublish)

## Overview

The [Docker][] images for the [ktools][] created by [nsimplex][].

This repository uses a forked version ([victorpopkov/ktools][]) which includes
the [#13](https://github.com/nsimplex/ktools/pull/13) fix, so that it could be
compiled on a more recent [GCC][].

## Usage

```bash
$ cd <your mod directory>
$ docker pull viktorpopkov/ktools
$ docker run --rm viktorpopkov/ktools krane --version
$ docker run --rm viktorpopkov/ktools ktech --version
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
$ docker run --rm -ti -w '/data/' -v "$(pwd):/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```shell script
$ docker run --rm \
    --mount src="$(pwd)",target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
    ktech images/example/* . --atlas images/example.xml
# or
$ docker run --rm -w '/data/' -v "$(pwd):/data/" viktorpopkov/ktools \
    ktech images/example/* . --atlas images/example.xml
```

### Windows

#### CMD

##### Interactive Shell

```shell script
$ docker run --rm --interactive --tty \
    --mount src="%CD%",target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
# or
$ docker run --rm -ti -w '/data/' -v "%CD%:/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```shell script
$ docker run --rm \
    --mount src="%CD%",target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
    ktech images/example/* . --atlas images/example.xml
# or
$ docker run --rm -w '/data/' -v "%CD%:/data/" viktorpopkov/ktools \
    ktech images/example/* . --atlas images/example.xml
```

#### PowerShell

##### Interactive Shell

```shell script
$ docker run --rm --interactive --tty \
    --mount src="${PWD}",target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
# or
$ docker run --rm -ti -w '/data/' -v "${PWD}:/data/" viktorpopkov/ktools
```

##### Non-interactive Shell

```shell script
$ docker run --rm \
    --mount src="${PWD}",target='/data/',type=bind \
    --workdir='/data/' \
    viktorpopkov/ktools
    ktech images/example/* . --atlas images/example.xml
# or
$ docker run --rm -w '/data/' -v "${PWD}:/data/" viktorpopkov/ktools \
    ktech images/example/* . --atlas images/example.xml
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[docker image alpine size]: https://img.shields.io/docker/image-size/viktorpopkov/ktools/debian?label=debian%20size
[docker image debian size]: https://img.shields.io/docker/image-size/viktorpopkov/ktools/alpine?label=alpine%20size
[docker]: https://www.docker.com/
[don't starve]: https://www.klei.com/games/dont-starve
[gcc]: https://gcc.gnu.org/
[github workflow ci status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/CI?label=CI
[github workflow publish status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-ktools/Publish?label=Publish
[ktools]: https://github.com/nsimplex/ktools
[nsimplex]: https://github.com/nsimplex
[victorpopkov/ktools]: https://github.com/victorpopkov/ktools
