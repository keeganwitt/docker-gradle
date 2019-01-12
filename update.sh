#!/usr/bin/env bash
set -o errexit -o nounset

gradleVersion=$(curl --fail --show-error --silent --location https://services.gradle.org/versions/current | jq --raw-output .version)
sha=$(curl --fail --show-error --silent --location https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256)

sed --regexp-extended --in-place "s/ENV GRADLE_VERSION .+/ENV GRADLE_VERSION ${gradleVersion}/" */Dockerfile
sed --regexp-extended --in-place "s/GRADLE_DOWNLOAD_SHA256=.+$/GRADLE_DOWNLOAD_SHA256=${sha}/" */Dockerfile
sed --regexp-extended --in-place "s/run.sh \"\\$\{image\}\" \".+\"/run.sh \"\\$\{image\}\" \"${gradleVersion}\"/" .travis.yml
