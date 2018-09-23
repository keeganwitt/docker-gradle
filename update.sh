#!/usr/bin/env bash
set -o errexit -o nounset

gradleVersion=${1}

sed --regexp-extended --in-place "s/ENV GRADLE_VERSION .+/ENV GRADLE_VERSION ${gradleVersion}/" */Dockerfile
sha=$(curl https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256)
sed --regexp-extended --in-place "s/GRADLE_DOWNLOAD_SHA256=.+$/GRADLE_DOWNLOAD_SHA256=${sha}/" */Dockerfile
sed --regexp-extended --in-place "s/run.sh \"\\$\{image\}\" \".+\"/run.sh \"\\$\{image\}\" \"${gradleVersion}\"/" .travis.yml
