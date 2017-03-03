#!/usr/bin/env bash
set -o errexit -o nounset

image=$1
expectedGradleVersion=$2

version=$(docker run --rm "${image}" gradle --version | grep  --extended-regexp "Gradle [0-9.]+" | grep  --extended-regexp --only-matching "[0-9.]+")
if [ "${version}" != "${expectedGradleVersion}" ]; then
    echo "version '${version}' does not match expected version '${expectedGradleVersion}'"
    exit 1
fi

if [ $(echo "${image}" | grep 'jre') = "" ]; then
    if [ "$(docker run --rm --volume "${PWD}/java-quickstart:/project" --workdir "/project" "${image}" gradle clean test | grep 'BUILD SUCCESSFUL')" = "" ]; then
        echo "java-quickstart test failed"
        exit 1
    fi
fi

echo "All tests succeeded"
