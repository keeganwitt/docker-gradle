# gradle-docker
This is the Git repo that will eventually (hopefully) become the official Docker images for Gradle.

## Instructions for use
For now, you'll have to build the images first until they're published on Docker Hub.

### Building a Gradle project
Run this from the directory of the Gradle project you want to build.

`docker run -it --rm -v "$PWD":/project -w /project --name gradle gradle:jdk8-latest-alpine gradle <gradle-task>`

## Instructions for a new Gradle release
1. Change `ENV GRADLE_VERSION` in all Dockerfiles to new version number.
1. Change `gradleVersion` (and `gradleMajorVersion` if applicable) variable(s) in _buildImages.sh_ to new version number(s).
1. Download the binary zip.
1. Run `sha256sum` on the above zip and change the `ARG GRADLE_DOWNLOAD_SHA256` in all Dockerfiles to new sha.
1. Run _buildImages.sh_.

### Prerequisites
* Docker
* sha256sum
