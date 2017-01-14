FROM openjdk:8-jdk

ENV GRADLE_VERSION 3.3
ARG GRADLE_DOWNLOAD_SHA256=668a65ea17037371a1952cca5f42ebc03329e15d3619aacb4c7dd5f4b39a8dfd

ENV GRADLE_HOME /opt/gradle
ENV PATH ${GRADLE_HOME}/bin:$PATH

WORKDIR /opt
RUN set -ex \
	&& wget -nv "http://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	&& echo "$GRADLE_DOWNLOAD_SHA256 *gradle-${GRADLE_VERSION}-bin.zip" | sha256sum -c - \
	\
	&& unzip gradle-${GRADLE_VERSION}-bin.zip \
	&& rm gradle-${GRADLE_VERSION}-bin.zip \
	&& mv "gradle-${GRADLE_VERSION}" /opt/gradle \
	\
	&& gradle --version

ARG USER_HOME_DIR="/root"
VOLUME "$USER_HOME_DIR/.gradle"

CMD ["gradle"]
