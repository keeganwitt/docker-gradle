FROM openjdk:8-jdk

ENV GRADLE_VERSION 3.2.1
ARG GRADLE_DOWNLOAD_SHA256=9843a3654d3e57dce54db06d05f18b664b95c22bf90c6becccb61fc63ce60689

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
