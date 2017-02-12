FROM openjdk:9-jre

CMD ["gradle"]

WORKDIR /opt
ENV GRADLE_HOME /opt/gradle
ENV PATH "${GRADLE_HOME}/bin:${PATH}"

ARG USER_HOME_DIR="/root"
VOLUME "${USER_HOME_DIR}/.gradle"

ENV GRADLE_VERSION 3.3
ARG GRADLE_DOWNLOAD_SHA256=c58650c278d8cf0696cab65108ae3c8d95eea9c1938e0eb8b997095d5ca9a292
RUN set -eu \
	&& echo "Installing build dependencies" \
	&& apt-get update \
	&& apt-get update && apt-get install -y --no-install-recommends \
		gnupg \
	&& rm -rf /var/lib/apt/lists/* \
	\
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
	&& echo "Cleaning up build dependencies" \
	&& echo $(apt-mark showauto) \
	&& apt-get remove -y --purge \
		gnupg \
	&& apt-get autoremove -y --purge \
	\
	&& gradle --version
