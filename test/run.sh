#!/usr/bin/env bash
set -o errexit -o nounset

image="${1}"
expectedGradleVersion="${2}"

if [[ $(id -u) -eq "1000" ]]; then
    user="gradle"
    home="/home/gradle"
else
    user="root"
    home="/root"
fi

version=$(docker run --user "${user}" --rm "${image}" gradle --no-daemon --version --quiet | grep --extended-regexp "^Gradle .+$" | cut -d ' ' -f2)
if [[ "${version}" != "${expectedGradleVersion}" ]]; then
    echo "version '${version}' does not match expected version '${expectedGradleVersion}'" >&2
    exit 1
fi

if [[ $(echo "${image}" | grep "jre") == "" ]]; then
    echo "Building Java project"
    if [[ $(docker run --user "${user}" --rm --volume "${PWD}/java-quickstart:${home}/project" --workdir "${home}/project" "${image}" gradle --no-daemon clean test | grep "BUILD SUCCESSFUL") == "" ]]; then
        echo "java-quickstart test failed" >&2
        exit 1
    fi
fi

echo "All tests succeeded"
