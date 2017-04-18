# docker-gradle

## Supported tags and respective Dockerfile links

* [jdk7](https://github.com/keeganwitt/docker-gradle/blob/master/jdk7/Dockerfile)
* [jdk7-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk7-alpine/Dockerfile)
* [jre7](https://github.com/keeganwitt/docker-gradle/blob/master/jre7/Dockerfile)
* [jre7-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jre7-alpine/Dockerfile)
* [latest, jdk8, jdk](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8/Dockerfile)
* [alpine, jdk8-alpine, jdk-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8-alpine/Dockerfile)
* [jre8, jre](https://github.com/keeganwitt/docker-gradle/blob/master/jre8/Dockerfile)
* [jre8-alpine, jre-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jre8-alpine/Dockerfile)

## What is Gradle?

[Gradle](https://gradle.org/) is a build tool with a focus on build automation and support for multi-language development. If you are building, testing, publishing, and deploying software on any platform, Gradle offers a flexible model that can support the entire development lifecycle from compiling and packaging code to publishing web sites. Gradle has been designed to support build automation across multiple languages and platforms including Java, Scala, Android, C/C++, and Groovy, and is closely integrated with development tools and continuous integration servers including Eclipse, IntelliJ, and Jenkins.

## How to use this image

### Building a Gradle project

Run this from the directory of the Gradle project you want to build.

`docker run --rm -v "$PWD":/project -w /project --name gradle gradle:latest gradle <gradle-task>`

<!--
### Reusing the Gradle cache

The local Gradle cache can be reused across containers by creating a volume and mounting it in */home/gradle/.gradle*.
Note that sharing between concurrently running containers doesn't work currently
(see [#851](https://github.com/gradle/gradle/issues/851)).

```
docker volume create --name gradle-cache
docker run -it -v gradle-cache:/home/gradle/.gradle gradle:alpine gradle build
```
-->

## Instructions for a new Gradle release

1. Change `ENV GRADLE_VERSION` in all Dockerfiles to new version number.
1. Download the binary zip.
1. Run `sha256sum` on the above zip and change the `ARG GRADLE_DOWNLOAD_SHA256` in all Dockerfiles to new sha.
1. Update _.travis.yml_.
1. Update [official-images](https://github.com/docker-library/official-images) (and [docs](https://github.com/docker-library/docs) if appropriate).

### Prerequisites

* Docker
* sha256sum

---
![Travis Build Status](https://travis-ci.org/keeganwitt/docker-gradle.svg?branch=master)
