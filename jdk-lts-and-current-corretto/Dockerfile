FROM amazoncorretto:21-al2023-jdk

COPY --from=amazoncorretto:23-al2023-jdk /usr/lib/jvm/java-23-amazon-corretto.x86_64 /usr/lib/jvm/java-23-amazon-corretto.x86_64
ENV JAVA_LTS_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64
ENV JAVA_CURRENT_HOME=/usr/lib/jvm/java-23-amazon-corretto.x86_64

CMD ["gradle"]

ENV GRADLE_HOME=/opt/gradle

RUN set -o errexit -o nounset \
    && dnf install -y \
        shadow-utils \
        unzip \
        wget \
        which \
        \
        findutils \
        \
        git \
        git-lfs \
        mercurial \
        subversion \
    && dnf clean all \
    && rm -rf /var/cache/yum \
    \
    && echo "Testing VCSes" \
    && which git \
    && which git-lfs \
    && which hg \
    && which svn

RUN set -o errexit -o nounset \
    && echo "Adding gradle user and group" \
    && groupadd --system --gid 1000 gradle \
    && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
    && mkdir /home/gradle/.gradle \
    && chown --recursive gradle:gradle /home/gradle \
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

ENV GRADLE_VERSION=8.10.2
ARG GRADLE_DOWNLOAD_SHA256=31c55713e40233a8303827ceb42ca48a47267a0ad4bab9177123121e71524c26
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
