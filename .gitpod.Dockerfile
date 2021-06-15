FROM gitpod/workspace-full

USER root

#update and upgrade apt packages
RUN echo "Updating apt packages"
RUN sudo apt-get update -qq

#install curl cmd
RUN sudo apt install curl -y

RUN echo "Installing Java"
ENV JAVA_VERSION_MAJOR=8u292
ENV JAVA_VERSION_MINOR=b10

ARG JAVA_BINARY_URL=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk${JAVA_VERSION_MAJOR}-${JAVA_VERSION_MINOR}/OpenJDK8U-jdk_x64_linux_hotspot_${JAVA_VERSION_MAJOR}${JAVA_VERSION_MINOR}.tar.gz
ARG JAVA_SHA=0949505fcf42a1765558048451bb2a22e84b3635b1a31dd6191780eeccaa4ada
RUN echo "Downloading java jdk"
RUN curl -LfsSo /tmp/openjdk.tar.gz ${JAVA_BINARY_URL} >> /dev/null && \
    \
    echo "Checking download with hash" && \
    echo "${JAVA_SHA} */tmp/openjdk.tar.gz" | sha256sum -c - >> /dev/null && \
    \
    echo "Create the java directory and change to it" && \
    mkdir -p /opt/java/openjdk >> /dev/null && \
    cd /opt/java/openjdk >> /dev/null && \
    \
    echo "Unziping Java" && \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1 >> /dev/null && \
    \
    echo "Cleaning downloaded files" && \
    rm -rf /tmp/openjdk.tar.gz
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="/opt/java/openjdk/bin:$PATH"

# Downloading and installing Maven
ENV MAVEN_HOME=/opt/maven
ARG MAVEN_VERSION=3.6.3
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /opt/maven /opt/maven/ref \
  && echo "Downlaoding maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C $MAVEN_HOME --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && sudo ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

ENV MAVEN_CONFIG "$USER_HOME/.m2"

# Downloading and installing Gradle
# 1- Define a constant with the version of gradle you want to install
ENV GRADLE_HOME=/opt/gradle
ENV GRADLE_VERSION=4.0.1

# 2- Define the URL where gradle can be downloaded from
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions

# 3- Define the SHA key to validate the gradle download
#    obtained from here https://gradle.org/release-checksums/
ARG GRADLE_SHA=d717e46200d1359893f891dab047fdab98784143ac76861b53c50dbd03b44fd4

# 4- Create the directories, download gradle, validate the download, install it, remove downloaded file and set links
RUN mkdir -p $GRADLE_HOME $GRADLE_HOME/ref \
  && echo "Downlaoding gradle hash" \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  \
  && echo "Checking download hash" \
  && echo "${GRADLE_SHA}  /tmp/gradle.zip" | sha256sum -c - \
  \
  && echo "Unziping gradle" \
  && unzip -d $GRADLE_HOME /tmp/gradle.zip \
   \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/gradle.zip \
  && sudo ln -s $GRADLE_HOME/gradle-${GRADLE_VERSION} /usr/bin/gradle

USER gitpod

# 5- Define environmental variables required by gradle
ENV GRADLE_USER_HOME $USER_HOME/cache
ENV PATH $PATH:$GRADLE_HOME/bin

VOLUME $GRADLE_USER_HOME

CMD [""]
