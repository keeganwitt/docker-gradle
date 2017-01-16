#!/usr/bin/env bash
set -e

gradleMajorVersion=3.3
gradleVersion=${gradleMajorVersion}

cd ../jdk7
docker build \
    -t gradle:jdk7-${gradleMajorVersion} \
    -t gradle:jdk7-${gradleVersion} \
    -t gradle:jdk7-latest \
    .

cd jre7
docker build \
    -t gradle:jre7-${gradleMajorVersion} \
    -t gradle:jre7-${gradleVersion} \
    -t gradle:jre7-latest \
    .

cd ../jdk7-alpine
docker build \
    -t gradle:jdk7-${gradleMajorVersion}-alpine \
    -t gradle:jdk7-${gradleVersion}-alpine \
    -t gradle:jdk7-alpine \
    .

cd ../jre7-alpine
docker build \
    -t gradle:jre7-${gradleMajorVersion}-alpine \
    -t gradle:jre7-${gradleVersion}-alpine \
    -t gradle:jre7-alpine \
    .

cd ../jdk8
docker build \
    -t gradle:jdk8-${gradleMajorVersion} \
    -t gradle:jdk8-${gradleVersion} \
    -t gradle:jdk8-latest \
    -t gradle:jdk-${gradleMajorVersion} \
    -t gradle:jdk-${gradleVersion} \
    -t gradle:jdk-latest \
    -t gradle:${gradleMajorVersion} \
    -t gradle:${gradleVersion} \
    -t gredle:latest \
    .

cd ../jre8
docker build \
    -t gradle:jre8-${gradleMajorVersion} \
    -t gradle:jre8-${gradleVersion} \
    -t gradle:jre8-latest \
    -t gradle:jre-${gradleMajorVersion} \
    -t gradle:jre-${gradleVersion} \
    -t gradle:jre-latest \
    .

cd ../jdk8-alpine
docker build \
    -t gradle:jdk8-${gradleMajorVersion}-alpine \
    -t gradle:jdk8-${gradleVersion}-alpine \
    -t gradle:jdk8-alpine \
    -t gradle:jdk-${gradleMajorVersion}-alpine \
    -t gradle:jdk-${gradleVersion}-alpine \
    -t gradle:jdk-alpine \
    -t gradle:${gradleMajorVersion}-alpine \
    -t gradle:${gradleVersion}-alpine \
    -t gradle:alpine \
    .

cd ../jre8-alpine
docker build \
    -t gradle:jre8-${gradleMajorVersion}-alpine \
    -t gradle:jre8-${gradleVersion}-alpine \
    -t gradle:jre8-alpine \
    -t gradle:jre-${gradleMajorVersion}-alpine \
    -t gradle:jre-${gradleVersion}-alpine \
    -t gradle:jre-alpine \
    .

cd ..
