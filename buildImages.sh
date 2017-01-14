#!/usr/bin/env bash
set -e

gradleMajorVersion=3.3
gradleVersion=${gradleMajorVersion}

cd jre7
docker build -t gradle:jre7-${gradleMajorVersion} -t gradle:jre7-${gradleVersion} -t gradle:jre7-latest .
cd ../jdk7
docker build -t gradle:jdk7-${gradleMajorVersion} -t gradle:jdk7-${gradleVersion} -t gradle:jdk7-latest .
cd ../jre7-alpine
docker build -t gradle:jre7-${gradleMajorVersion}-alpine -t gradle:jre7-${gradleVersion}-alpine -t gradle:jre7-latest-alpine .
cd ../jdk7-alpine
docker build -t gradle:jdk7-${gradleMajorVersion}-alpine -t gradle:jdk7-${gradleVersion}-alpine -t gradle:jdk7-latest-alpine .

cd ../jre8
docker build -t gradle:jre8-${gradleMajorVersion} -t gradle:jre8-${gradleVersion} -t gradle:jre8-latest .
cd ../jdk8
docker build -t gradle:jdk8-${gradleMajorVersion} -t gradle:jdk8-${gradleVersion} -t gradle:jdk8-latest .
cd ../jre8-alpine
docker build -t gradle:jre8-${gradleMajorVersion}-alpine -t gradle:jre8-${gradleVersion}-alpine -t gradle:jre8-latest-alpine .
cd ../jdk8-alpine
docker build -t gradle:jdk8-${gradleMajorVersion}-alpine -t gradle:jdk8-${gradleVersion}-alpine -t gradle:jdk8-latest-alpine .

cd ..
