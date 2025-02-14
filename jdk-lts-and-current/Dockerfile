FROM eclipse-temurin:21-jdk-noble

COPY --from=eclipse-temurin:23-jdk-noble /opt/java/openjdk /opt/java/openjdk23
RUN set -o errexit -o nounset \
    && ln --symbolic /opt/java/openjdk /opt/java/openjdk21
ENV JAVA_LTS_HOME=/opt/java/openjdk21
ENV JAVA_CURRENT_HOME=/opt/java/openjdk23

CMD ["gradle"]

ENV GRADLE_HOME=/opt/gradle

RUN set -o errexit -o nounset \
    && echo "Renaming ubuntu user and group to gradle" \
    && groupmod --new-name gradle ubuntu \
    && mkdir /home/gradle \
    && usermod --login gradle --home /home/gradle --groups gradle ubuntu \
    && chown gradle /home/gradle \
    && mkdir /home/gradle/.gradle \
    && chown --recursive gradle:gradle /home/gradle \
    && chmod --recursive o+rwx /home/gradle \
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
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        unzip \
        wget \
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

ENV GRADLE_VERSION=8.12.1
ARG GRADLE_DOWNLOAD_SHA256=8d97a97984f6cbd2b85fe4c60a743440a347544bf18818048e611f5288d46c94
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version
