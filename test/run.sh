#!/usr/bin/env bash
set -euo pipefail

image=${1}
expectedGradleVersion=${2}

version=`docker run --rm "${image}" gradle --version | grep -E "Gradle [0-9.]+" | grep -Eo "[0-9.]+"`
if [ "${version}" != "${expectedGradleVersion}" ]; then
    echo "version '${version}' does not match expected version '${expectedGradleVersion}'"
    exit 1
fi

if [ `echo "${image}" | grep 'jre'` == "" ]; then
    if [ "`docker run --rm -v "${PWD}/java-quickstart:/project" -w /project "${image}" gradle clean test | grep 'BUILD SUCCESSFUL'`" == "" ]; then
        echo "java-quickstart test failed"
        exit 1
    fi
fi

echo "All tests succeeded"
