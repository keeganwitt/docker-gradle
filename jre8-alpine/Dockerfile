FROM openjdk:8-jre-alpine

CMD ["gradle"]

WORKDIR /opt
ENV GRADLE_HOME /opt/gradle
ENV PATH "${GRADLE_HOME}/bin:${PATH}"

ARG USER_HOME_DIR="/root"
VOLUME "${USER_HOME_DIR}/.gradle"

ENV GRADLE_VERSION 3.3
ARG GRADLE_DOWNLOAD_SHA256=c58650c278d8cf0696cab65108ae3c8d95eea9c1938e0eb8b997095d5ca9a292
RUN set -eu \
	&& echo "Installing dependencies" \
	&& apk add --no-cache \
		bash \
		libstdc++ \
	\
	&& echo "Installing build dependencies" \
	&& apk add --no-cache --virtual .build-deps \
		ca-certificates \
		openssl \
		unzip \
	\
	&& echo "Downloading Gradle" \
	&& wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}" \
	\
	&& apk del .build-deps \
	\
	&& gradle --version
