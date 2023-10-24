#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

for JAVA_VERSION in '17.0.8' '21.0.0'; do
  GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${JDK_VERSION}/graalvm-community-jdk-${JDK_VERSION}_linux-x64_bin.tar.gz
  echo "${JAVA_VERSION}"
  curl --fail --location --silent "${GRAALVM_PKG}" | sha256sum | cut -d' ' -f1
done
