FROM openjdk:9-jre

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.5.1

# cacerts from JDK 8u152 to workaround http://bugs.java.com/view_bug.do?bug_id=8189357
COPY cacerts /etc/ssl/certs/java/cacerts

ARG GRADLE_DOWNLOAD_SHA256=3e2ea0d8b96605b7c528768f646e0975bd9822f06df1f04a64fd279b1a17805e
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
	&& echo "Adding gradle user and group" \
	&& groupadd --system --gid 1000 gradle \
	&& useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
	&& mkdir /home/gradle/.gradle \
	&& chown --recursive gradle:gradle /home/gradle \
	\
	&& echo "Symlinking root Gradle cache to gradle Gradle cache" \
	&& ln -s /home/gradle/.gradle /root/.gradle

# Create Gradle volume
USER gradle
VOLUME "/home/gradle/.gradle"
WORKDIR /home/gradle

RUN set -o errexit -o nounset \
	&& echo "Testing Gradle installation" \
	&& gradle --version
