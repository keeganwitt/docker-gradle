FROM openjdk:7u121-jre-alpine

ENV GRADLE_VERSION 3.3
ARG GRADLE_DOWNLOAD_SHA256=c58650c278d8cf0696cab65108ae3c8d95eea9c1938e0eb8b997095d5ca9a292

ENV GRADLE_HOME /opt/gradle
ENV PATH ${GRADLE_HOME}/bin:$PATH

RUN set -ex \
	&& apk add --no-cache \
		libstdc++=5.3.0-r0 \
		unzip

ARG USER_HOME_DIR="/root"
VOLUME "$USER_HOME_DIR/.gradle"

WORKDIR /opt
RUN set -ex \
	&& echo "Downloading Gradle" \
	&& wget "http://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	&& echo "$GRADLE_DOWNLOAD_SHA256 *gradle-${GRADLE_VERSION}-bin.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle-${GRADLE_VERSION}-bin.zip \
	&& apk del unzip \
	&& rm gradle-${GRADLE_VERSION}-bin.zip \
	&& mv "gradle-${GRADLE_VERSION}" /opt/gradle \
	\
	&& echo "Testing Gradle installation" \
	&& gradle --version

CMD ["gradle"]
