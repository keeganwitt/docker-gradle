FROM ubuntu:jammy

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle

RUN set -o errexit -o nounset \
    && echo "Adding gradle user and group" \
    && groupadd --system --gid 1000 gradle \
    && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
    && mkdir /home/gradle/.gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln --symbolic /home/gradle/.gradle /root/.gradle \
   \
   && echo "Ensuring Gradle detects installed JDKs" \
   && echo "org.gradle.java.installations.auto-detect=false" > /home/gradle/.gradle/gradle.properties \
   && echo "org.gradle.java.installations.auto-download=false" >> /home/gradle/.gradle/gradle.properties \
   && echo "org.gradle.java.installations.fromEnv=JAVA_LTS_HOME,JAVA_CURRENT_HOME" >> /home/gradle/.gradle/gradle.properties

VOLUME /home/gradle/.gradle

WORKDIR /home/gradle

RUN set -o errexit -o nounset \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        binutils \
        ca-certificates \
        curl \
        fontconfig \
        locales \
        p11-kit \
        tzdata \
        unzip \
        wget \
        \
        gcc \
        libc-dev \
        libz-dev \
        zlib1g-dev \
        \
        bzr \
        git \
        git-lfs \
        mercurial \
        openssh-client \
        subversion \
    && rm --recursive --force /var/lib/apt/lists/* \
    \
    && echo "Testing VCSes" \
    && which bzr \
    && which git \
    && which git-lfs \
    && which hg \
    && which svn

ENV JAVA_HOME=/opt/java/graalvm
ENV JAVA_LTS_HOME /opt/java/graalvm21
ENV JAVA_CURRENT_HOME /opt/java/graalvm22
RUN set -o errexit -o nounset \
    && mkdir /opt/java \
    \
    && echo "Downloading LTS GraalVM" \
    && JDK_VERSION=21.0.2 \
    && GRAALVM_AMD64_DOWNLOAD_SHA256=b048069aaa3a99b84f5b957b162cc181a32a4330cbc35402766363c5be76ae48 \
    && GRAALVM_AARCH64_DOWNLOAD_SHA256=a34be691ce68f0acf4655c7c6c63a9a49ed276a11859d7224fd94fc2f657cd7a \
    && ARCHITECTURE=$(dpkg --print-architecture) \
    && if [ "${ARCHITECTURE}" = "amd64" ]; then GRAALVM_ARCHITECTURE=linux-x64; fi \
    && if [ "${ARCHITECTURE}" = "arm64" ]; then GRAALVM_ARCHITECTURE=linux-aarch64; fi \
    && GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${JDK_VERSION}/graalvm-community-jdk-${JDK_VERSION}_${GRAALVM_ARCHITECTURE}_bin.tar.gz \
    && wget --no-verbose --output-document=graalvm.tar.gz "${GRAALVM_PKG}" \
    \
    && echo "Checking LTS GraalVM download hash" \
    && if [ "${ARCHITECTURE}" = "amd64" ]; then GRAALVM_DOWNLOAD_SHA256="${GRAALVM_AMD64_DOWNLOAD_SHA256}"; fi \
    && if [ "${ARCHITECTURE}" = "arm64" ]; then GRAALVM_DOWNLOAD_SHA256="${GRAALVM_AARCH64_DOWNLOAD_SHA256}"; fi \
    && echo "${GRAALVM_DOWNLOAD_SHA256} *graalvm.tar.gz" | sha256sum --check - \
    \
    && echo "Installing LTS GraalVM" \
    && tar --extract --gunzip --file graalvm.tar.gz \
    && rm graalvm.tar.gz \
    && mv graalvm-* /opt/java/graalvm21 \
    \
    && echo "Downloading current GraalVM" \
    && JDK_VERSION=22.0.0 \
    && GRAALVM_AMD64_DOWNLOAD_SHA256=e5eeb486a23101753f18181d002c3ede9da13c463fb61d3ea448abe774db0657 \
    && GRAALVM_AARCH64_DOWNLOAD_SHA256=da9a0e11b110ebccff33ade502516d00f574ec3247868007e452cef4143e0904 \
    && ARCHITECTURE=$(dpkg --print-architecture) \
    && if [ "${ARCHITECTURE}" = "amd64" ]; then GRAALVM_ARCHITECTURE=linux-x64; fi \
    && if [ "${ARCHITECTURE}" = "arm64" ]; then GRAALVM_ARCHITECTURE=linux-aarch64; fi \
    && GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${JDK_VERSION}/graalvm-community-jdk-${JDK_VERSION}_${GRAALVM_ARCHITECTURE}_bin.tar.gz \
    && wget --no-verbose --output-document=graalvm.tar.gz "${GRAALVM_PKG}" \
    \
    && echo "Checking current GraalVM download hash" \
    && if [ "${ARCHITECTURE}" = "amd64" ]; then GRAALVM_DOWNLOAD_SHA256="${GRAALVM_AMD64_DOWNLOAD_SHA256}"; fi \
    && if [ "${ARCHITECTURE}" = "arm64" ]; then GRAALVM_DOWNLOAD_SHA256="${GRAALVM_AARCH64_DOWNLOAD_SHA256}"; fi \
    && echo "${GRAALVM_DOWNLOAD_SHA256} *graalvm.tar.gz" | sha256sum --check - \
    \
    && echo "Installing current GraalVM" \
    && tar --extract --gunzip --file graalvm.tar.gz \
    && rm graalvm.tar.gz \
    && mv graalvm-* /opt/java/graalvm22 \
    \
    && echo "Default Java to LTS GraalVM" \
    && ln --symbolic /opt/java/graalvm21 /opt/java/graalvm \
    && for bin in /opt/java/graalvm21/bin/*; do \
        base="$(basename "$bin")"; \
        [ ! -e "/usr/bin/$base" ]; \
        update-alternatives --install "/usr/bin/${base}" "${base}" "${bin}" 1; \
    done \
    \
    && echo "Testing GraalVM installation" \
    && java --version \
    && javac --version \
    && native-image --version

ENV GRADLE_VERSION 8.8
ARG GRADLE_DOWNLOAD_SHA256=a4b4158601f8636cdeeab09bd76afb640030bb5b144aafe261a5e8af027dc612
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking Gradle download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version \
    \
    # chown last so that it applies to /home/gradle/.gradle/native
    && chown --recursive gradle:gradle /home/gradle
