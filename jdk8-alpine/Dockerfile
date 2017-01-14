FROM openjdk:8-jdk-alpine

ENV GRADLE_VERSION 3.3
ARG GRADLE_DOWNLOAD_SHA256=c58650c278d8cf0696cab65108ae3c8d95eea9c1938e0eb8b997095d5ca9a292

ENV GRADLE_HOME /opt/gradle
ENV PATH ${GRADLE_HOME}/bin:$PATH

RUN set -ex \
	&& apk add --no-cache \
		libstdc++=5.3.0-r0 \
		unzip

WORKDIR /opt
RUN set -ex \
	&& wget "http://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	&& echo "$GRADLE_DOWNLOAD_SHA256 *gradle-${GRADLE_VERSION}-bin.zip" | sha256sum -c - \
	\
	&& unzip gradle-${GRADLE_VERSION}-bin.zip \
	&& apk del unzip \
	&& rm gradle-${GRADLE_VERSION}-bin.zip \
	&& mv "gradle-${GRADLE_VERSION}" /opt/gradle \
	\
	&& gradle --version

ARG USER_HOME_DIR="/root"
VOLUME "$USER_HOME_DIR/.gradle"

CMD ["gradle"]
