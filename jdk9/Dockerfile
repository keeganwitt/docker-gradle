FROM openjdk:9-jdk

CMD ["gradle"]

WORKDIR /opt
ENV GRADLE_HOME /opt/gradle
ENV PATH "${GRADLE_HOME}/bin:${PATH}"

VOLUME "/root/.gradle"

ENV GRADLE_VERSION 3.4
ARG GRADLE_DOWNLOAD_SHA256=72d0cd4dcdd5e3be165eb7cd7bbd25cf8968baf400323d9ab1bba622c3f72205
RUN set -eu \
	&& echo "Downloading Gradle" \
	&& wget -nv -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}" \
	\
	&& gradle --version
