#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

gradleVersion=$(curl --fail --show-error --silent --location https://services.gradle.org/versions/current | jq --raw-output .version)
sha=$(curl --fail --show-error --silent --location "https://downloads.gradle.org/distributions/gradle-${gradleVersion}-bin.zip.sha256")

sed --regexp-extended --in-place "s/ENV GRADLE_VERSION .+$/ENV GRADLE_VERSION ${gradleVersion}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/GRADLE_DOWNLOAD_SHA256=.+$/GRADLE_DOWNLOAD_SHA256=${sha}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/expectedGradleVersion: .+$/expectedGradleVersion: \"${gradleVersion}\"/" .github/workflows/ci.yaml

latestGraal17=$(curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1' | jq -r 'map(select(.tag_name | contains("jdk-17"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JDK_VERSION=[^ ]+/JDK_VERSION=${latestGraal17}/" ./jdk17*graal/Dockerfile

latestGraal21=$( curl --silent --location 'https://api.github.com/repos/graalvm/graalvm-ce-builds/releases?per_page=6&page=1' | jq -r 'map(select(.tag_name | contains("jdk-21"))) | .[0].tag_name | sub("jdk-"; "")')
sed --regexp-extended --in-place "s/JDK_VERSION=[^ ]+/JDK_VERSION=${latestGraal21}/" ./jdk21*graal/Dockerfile

echo "Latest Gradle version is ${gradleVersion}"
echo "Latest Graal 17 version is ${latestGraal17}"
echo "Latest Graal 21 version is ${latestGraal21}"
