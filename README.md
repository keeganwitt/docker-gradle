# docker-gradle

## Supported tags and respective Dockerfile links

* [jdk8, jdk8-noble](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8-noble/Dockerfile)
* [jdk8-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8-jammy/Dockerfile)
* [jdk8-focal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8-focal/Dockerfile)
* [jdk8-corretto](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8-corretto/Dockerfile)
* [jdk11, jdk11-noble](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-noble/Dockerfile)
* [jdk11-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-jammy/Dockerfile)
* [jdk11-focal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-focal/Dockerfile)
* [jdk11-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-alpine/Dockerfile)
* [jdk11, jdk11-corretto](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-corretto/Dockerfile)
* [jdk17, jdk17-noble](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-noble/Dockerfile)
* [jdk17-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-jammy/Dockerfile)
* [jdk17-focal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-focal/Dockerfile)
* [jdk17-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-alpine/Dockerfile)
* [jdk17-corretto](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-corretto/Dockerfile)
* [jdk17-noble-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-noble-graal/Dockerfile)
* [jdk17-focal-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-focal-graal/Dockerfile)
* [jdk21, jdk21-noble, latest](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-noble/Dockerfile)
* [jdk21-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-jammy/Dockerfile)
* [jdk21-alpine, alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-alpine/Dockerfile)
* [jdk21-corretto, corretto](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-corretto/Dockerfile)
* [jdk21-noble-graal, jdk21-graal, graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-noble-graal/Dockerfile)
* [jdk21-jammy-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-jammy-graal/Dockerfile)
* [jdk23, jdk23-noble](https://github.com/keeganwitt/docker-gradle/blob/master/jdk23/Dockerfile)
* [jdk23-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk23-alpine/Dockerfile)
* [jdk23-corretto](https://github.com/keeganwitt/docker-gradle/blob/master/jdk23-corretto/Dockerfile)
* [jdk23-noble-graal, jdk23-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk23-noble-graal/Dockerfile)
* [jdk-lts-and-current](https://github.com/keeganwitt/docker-gradle/blob/master/jdk-lts-and-current/Dockerfile)
* [jdk-lts-and-current-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk-lts-and-current-alpine/Dockerfile)
* [jdk-lts-and-current-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk-lts-and-current-graal/Dockerfile)

### lts-and-current images

Gradle's support for new Java releases historically has lagged for multiple months.
This means most users wanting to use the latest Java release will need to do so using toolchains.
Toolchains are 
documented [here](https://docs.gradle.org/current/userguide/toolchains.html) and [here](https://graalvm.github.io/native-build-tools/latest/gradle-plugin.html#configuration-toolchains) for GraalVM.
The lts-and-current images provide both the latest LTS JDK and the latest (LTS or non-LTS) JDK.
This allows Gradle to be launched with a supported JDK (the latest LTS release)
and configure the compilation using toolchains to use the latest current JDK.
This is done by putting the content below in `/home/gradle/.gradle/gradle.properties`.
```properties
org.gradle.java.installations.auto-detect=false
org.gradle.java.installations.auto-download=false
org.gradle.java.installations.fromEnv=JAVA_LTS_HOME,JAVA_CURRENT_HOME
```
The `JAVA_LTS_HOME` environment variable points to the path
where the latest LTS JDK is installed and `JAVA_CURRENT_HOME` points to the latest current JDK.
These may point to the same path if the latest JDK is an LTS release.

## What is Gradle?

[Gradle](https://gradle.org/) is a build tool with a focus on build automation and support for multi-language development. If you are building, testing, publishing, and deploying software on any platform, Gradle offers a flexible model that can support the entire development lifecycle from compiling and packaging code to publishing websites. Gradle has been designed to support build automation across multiple languages and platforms including Java, Scala, Android, C/C++, and Groovy, and is closely integrated with development tools and continuous integration servers including Eclipse, IntelliJ, and Jenkins.

## How to use this image

If you are mounting a volume and the uid/gid running Docker is not *1000*, you should run as user *root* (`-u root`).
*root* is also the default, so you can also simply not specify a user.

### Building a Gradle project

Run this from the directory of the Gradle project you want to build.

#### Bash/Zsh

`docker run --rm -u gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:latest gradle <gradle-task>`

#### PowerShell

`docker run --rm -u gradle -v "${pwd}:/home/gradle/project" -w /home/gradle/project gradle:latest gradle <gradle-task>`

#### Windows CMD

`docker run --rm -u gradle -v "%cd%:/home/gradle/project" -w /home/gradle/project gradle:latest gradle <gradle-task>`

Note the above command runs using uid/gid 1000 (user *gradle*) to avoid running as root.

### Reusing the Gradle cache

The local Gradle cache can be reused across containers by creating a volume and mounting it to _/home/gradle/.gradle_.
Note that sharing between concurrently running containers doesn't work currently
(see [#851](https://github.com/gradle/gradle/issues/851)).

Also, currently it's [not possible](https://github.com/moby/moby/issues/3465) to override the volume declaration of the parent.
So if you are using this image as a base image and want the Gradle cache to be written into the next layer, you will need to use a new user (or use the `--gradle-user-home`/`-g` argument) so that a new cache is created that isn't mounted to a volume.

```
docker volume create --name gradle-cache
docker run --rm -u gradle -v gradle-cache:/home/gradle/.gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:latest gradle <gradle-task>
```

## Instructions for a new Gradle release

1. Run `update.sh` or `update.ps1`.
1. Commit and push the changes.
1. Update [official-images](https://github.com/docker-library/official-images) (and [docs](https://github.com/docker-library/docs) if appropriate).

---
[![Build status badge](https://github.com/keeganwitt/docker-gradle/workflows/GitHub%20CI/badge.svg)](https://github.com/keeganwitt/docker-gradle/actions?query=workflow%3A%22GitHub+CI%22)
