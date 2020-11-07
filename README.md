# docker-gradle

## Supported tags and respective Dockerfile links

* [latest, latest-hotspot, jdk8, jdk8-hotspot, jdk, jdk-hotspot](https://github.com/keeganwitt/docker-gradle/blob/master/hotspot/jdk8/Dockerfile)
* [latest-openj9, jdk8-openj9, jdk-openj9](https://github.com/keeganwitt/docker-gradle/blob/master/openj9/jdk8/Dockerfile)
* [jre8, jre8-hotspot, jre, jre-hotspot](https://github.com/keeganwitt/docker-gradle/blob/master/hotspot/jre8/Dockerfile)
* [jre8-openj9, jre-openj9](https://github.com/keeganwitt/docker-gradle/blob/master/openj9/jre8/Dockerfile)
* [jdk11, jdk11-hotspot](https://github.com/keeganwitt/docker-gradle/blob/master/hotspot/jdk11/Dockerfile)
* [jdk11-openj9](https://github.com/keeganwitt/docker-gradle/blob/master/openj9/jdk11/Dockerfile)
* [jre11, jre11-hotspot](https://github.com/keeganwitt/docker-gradle/blob/master/hotspot/jre11/Dockerfile)
* [jre11-openj9](https://github.com/keeganwitt/docker-gradle/blob/master/openj9/jre11/Dockerfile)
* [jdk15, jdk15-hotspot](https://github.com/keeganwitt/docker-gradle/blob/master/hotspot/jdk15/Dockerfile)
* [jdk15-openj9](https://github.com/keeganwitt/docker-gradle/blob/master/openj9/jdk15/Dockerfile)
* [jre15, jre15-hotspot](https://github.com/keeganwitt/docker-gradle/blob/master/hotspot/jre15/Dockerfile)
* [jre15-openj9](https://github.com/keeganwitt/docker-gradle/blob/master/openj9/jre15/Dockerfile)

## What is Gradle?

[Gradle](https://gradle.org/) is a build tool with a focus on build automation and support for multi-language development. If you are building, testing, publishing, and deploying software on any platform, Gradle offers a flexible model that can support the entire development lifecycle from compiling and packaging code to publishing web sites. Gradle has been designed to support build automation across multiple languages and platforms including Java, Scala, Android, C/C++, and Groovy, and is closely integrated with development tools and continuous integration servers including Eclipse, IntelliJ, and Jenkins.

## How to use this image

If you are mounting a volume and the uid/gid running Docker is not *1000*, you should run as user *root* (`-u root`).
*root* is also the default, so you can also simply not specify a user.

### Building a Gradle project

Run this from the directory of the Gradle project you want to build.

#### Bash/Zsh

`docker run --rm -u gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:latest gradle <gradle-task>`

#### PowerShell

`docker run --rm -v "${pwd}:/home/gradle/project" -w /home/gradle/project gradle:latest gradle <gradle-task>`

#### Windows CMD

`docker run --rm -v "%cd%:/home/gradle/project" -w /home/gradle/project gradle:latest gradle <gradle-task>`

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
![Travis Build Status](https://travis-ci.org/keeganwitt/docker-gradle.svg?branch=master)
