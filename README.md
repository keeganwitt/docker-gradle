# docker-gradle

## Supported tags and respective Dockerfile links

* [jdk8, jdk8-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8/Dockerfile)
* [jdk8-focal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk8-focal/Dockerfile)
* [jdk11, jdk11-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11/Dockerfile)
* [jdk11-focal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-focal/Dockerfile)
* [jdk11-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk11-alpine/Dockerfile)
* [jdk17, jdk17-jammy, latest](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17/Dockerfile)
* [jdk17-focal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-focal/Dockerfile)
* [jdk17-alpine, alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-alpine/Dockerfile)
* [jdk17-graal, graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-graal/Dockerfile)
* [jdk17-focal-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17-focal-graal/Dockerfile)
* [jdk21, jdk21-jammy](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21/Dockerfile)
* [jdk21-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-alpine/Dockerfile)
* [jdk21-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk21-graal/Dockerfile)
* [jdk17and21](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17and21/Dockerfile)
* [jdk17and21-alpine](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17and21-alpine/Dockerfile)
* [jdk17and21-graal](https://github.com/keeganwitt/docker-gradle/blob/master/jdk17and21-graal/Dockerfile)

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

### Java 21 with Gradle 8.4

Gradle 8.4 supported compilation targeting Java 21 bytecode, but not executing Gradle using Java 21. The [release notes](https://docs.gradle.org/8.4/release-notes.html#jvm) say

> Gradle now supports using Java 21 for compiling, testing, and starting other Java programs. This can be accomplished using toolchains.

> Currently, you cannot run Gradle on Java 21 because Kotlin lacks support for JDK 21. However, support for running Gradle with Java 21 is expected in future versions.

They also note this in their [compatibility guide](https://docs.gradle.org/current/userguide/compatibility.html).

The jdk17and21 images contain both Java 17 (for running Gradle) and Java 21 (for use in the toolchain to compile JVM classes). The image also sets the options below for you in `~/.gradle/gradle.properties`, to instruct Gradle to use the Java 21 installation. It sets two environment variables with the paths of each Java installation (`JAVA17_HOME` and `JAVA21_HOME`). `JAVA17_HOME` and `JAVA_HOME` are the same path.

```
org.gradle.java.installations.auto-detect=false
org.gradle.java.installations.auto-download=false
org.gradle.java.installations.fromEnv=JAVA21_HOME
```

To take advantage of this setup, you need to configure your build file to use Java 21 like below (the example shows how to configure both the Java and Kotlin plugins).

*Groovy DSL*

```groovy
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

kotlin {
    jvmToolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}
```

*Kotlin DSL*

```kotlin
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}

kotlin {
    jvmToolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}
```

## Instructions for a new Gradle release

1. Run `update.sh` or `update.ps1`.
1. Commit and push the changes.
1. Update [official-images](https://github.com/docker-library/official-images) (and [docs](https://github.com/docker-library/docs) if appropriate).

---
[![Build status badge](https://github.com/keeganwitt/docker-gradle/workflows/GitHub%20CI/badge.svg)](https://github.com/keeganwitt/docker-gradle/actions?query=workflow%3A%22GitHub+CI%22)
