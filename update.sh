#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

gradleVersion=$(curl --fail --show-error --silent --location https://services.gradle.org/versions/current | jq --raw-output .version)
sha=$(curl --fail --show-error --silent --location "https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256")

sed --regexp-extended --in-place "s/ENV GRADLE_VERSION .+$/ENV GRADLE_VERSION ${gradleVersion}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/GRADLE_DOWNLOAD_SHA256=.+$/GRADLE_DOWNLOAD_SHA256=${sha}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/expectedGradleVersion: .+$/expectedGradleVersion: \"${gradleVersion}\"/" .github/workflows/ci.yaml

graal17Version=$(curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1' | jq -r 'map(select(.tag_name | contains("jdk-17"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JAVA_VERSION=[^ ]+/JAVA_VERSION=${graal17Version}/" ./jdk17-graal/Dockerfile
sed --regexp-extended --in-place "s/JAVA_VERSION=[^ ]+/JAVA_VERSION=${graal17Version}/" ./jdk17-focal-graal/Dockerfile
graal17amd64Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-x64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
graal17aarch64Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal17Version}/graalvm-community-jdk-${graal17Version}_linux-aarch64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
sed --regexp-extended --in-place "s/GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AMD64_DOWNLOAD_SHA256=${graal17amd64Sha}/" ./jdk17-graal/Dockerfile
sed --regexp-extended --in-place "s/GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal17aarch64Sha}/" ./jdk17-graal/Dockerfile
sed --regexp-extended --in-place "s/GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AMD64_DOWNLOAD_SHA256=${graal17amd64Sha}/" ./jdk17-focal-graal/Dockerfile
sed --regexp-extended --in-place "s/GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal17aarch64Sha}/" ./jdk17-focal-graal/Dockerfile

graal21Version=$( curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1' | jq -r 'map(select(.tag_name | contains("jdk-21"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JAVA_VERSION=[^ ]+/JAVA_VERSION=${graal21Version}/" ./jdk21-graal/Dockerfile
graal21amd64Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-x64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
graal21aarch64Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal21Version}/graalvm-community-jdk-${graal21Version}_linux-aarch64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
sed --regexp-extended --in-place "s/GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AMD64_DOWNLOAD_SHA256=${graal21amd64Sha}/" ./jdk21-graal/Dockerfile
sed --regexp-extended --in-place "s/GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal21aarch64Sha}/" ./jdk21-graal/Dockerfile

graal22Version=$( curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=12&page=1' | jq -r 'map(select(.tag_name | contains("jdk-22"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JAVA_VERSION=[^ ]+/JAVA_VERSION=${graal22Version}/" ./jdk-lts-and-current-graal/Dockerfile
graal22amd64Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal22Version}/graalvm-community-jdk-${graal22Version}_linux-x64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
graal22aarch64Sha=$(curl --fail --location --silent "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${graal22Version}/graalvm-community-jdk-${graal22Version}_linux-aarch64_bin.tar.gz" | sha256sum | cut -d' ' -f1)
sed --regexp-extended --in-place "s/GRAALVM_AMD64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AMD64_DOWNLOAD_SHA256=${graal22amd64Sha}/" ./jdk-lts-and-current-graal/Dockerfile
sed --regexp-extended --in-place "s/GRAALVM_AARCH64_DOWNLOAD_SHA256=[^ ]+/GRAALVM_AARCH64_DOWNLOAD_SHA256=${graal22aarch64Sha}/" ./jdk-lts-and-current-graal/Dockerfile

echo "Latest Gradle version is ${gradleVersion}"
echo "Latest Graal 17 version is ${graal17Version}"
echo "Latest Graal 21 version is ${graal21Version}"
echo "Latest Graal 22 version is ${graal22Version}"

echo "Graal 17 AMD64 hash is ${graal17amd64Sha}"
echo "Graal 17 AARCH64 hash is ${graal17aarch64Sha}"
echo "Graal 21 AMD64 hash is ${graal21amd64Sha}"
echo "Graal 21 AARCH64 hash is ${graal21aarch64Sha}"
echo "Graal 22 AMD64 hash is ${graal22amd64Sha}"
echo "Graal 22 AARCH64 hash is ${graal22aarch64Sha}"
