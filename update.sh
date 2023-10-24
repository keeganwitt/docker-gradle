#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

gradleVersion=$(curl --fail --show-error --silent --location https://services.gradle.org/versions/current | jq --raw-output .version)
sha=$(curl --fail --show-error --silent --location "https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256")

sed --regexp-extended --in-place "s/ENV GRADLE_VERSION .+$/ENV GRADLE_VERSION ${gradleVersion}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/GRADLE_DOWNLOAD_SHA256=.+$/GRADLE_DOWNLOAD_SHA256=${sha}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/expectedGradleVersion: .+$/expectedGradleVersion: \"${gradleVersion}\"/" .github/workflows/ci.yaml

graal17Version=$(curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1' | jq -r 'map(select(.tag_name | contains("jdk-17"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JAVA_VERSION=[^ ]+/JAVA_VERSION=${graal17Version}/" ./jdk17*graal/Dockerfile
graal17Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-x64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
sed --regexp-extended --in-place "s/GRAALVM_DOWNLOAD_SHA256=[^ ]+/GRAALVM_DOWNLOAD_SHA256=${graal17Sha}/" ./jdk17*graal/Dockerfile

graal21Version=$( curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1' | jq -r 'map(select(.tag_name | contains("jdk-21"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JAVA_VERSION=[^ ]+/JAVA_VERSION=${graal21Version}/" ./jdk21*graal/Dockerfile
graal21Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-x64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
sed --regexp-extended --in-place "s/GRAALVM_DOWNLOAD_SHA256=[^ ]+/GRAALVM_DOWNLOAD_SHA256=${graal21Sha}/" ./jdk21*graal/Dockerfile

echo "Latest Gradle version is ${gradleVersion}"
echo "Latest Graal 17 version is ${graal17Version}"
echo "Latest Graal 21 version is ${graal21Version}"
