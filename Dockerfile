FROM ubuntu:16.04

MAINTAINER Vlad Vesa <vlad.vesa89@gmail.com>

ENV ANDROID_HOME /opt/android-sdk

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_VERSION="3859397"

WORKDIR /tmp

# Installing packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        lib32z1 \
        lib32z1-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libxslt-dev \
        libxml2-dev \
        unzip \
        zip \
        software-properties-common \
        zlib1g-dev && \
    apt-add-repository -y ppa:openjdk-r/ppa && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/ && \
    apt-get clean

# Install Android SDK
RUN wget -q -O tools.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip -q tools.zip && \
    rm -fr $ANDROID_HOME tools.zip && \
    mkdir -p $ANDROID_HOME && \
    mv tools $ANDROID_HOME/tools && \

    mkdir -p $ANDROID_HOME/licenses && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license && \

    # Install Android components
    cd $ANDROID_HOME && \
    
    echo "Install android-26" && \
    tools/bin/sdkmanager "platforms;android-26" && \

    echo "Install platform-tools" && \
    tools/bin/sdkmanager "platform-tools" && \

    echo "Install build-tools-26.0.1" && \
    tools/bin/sdkmanager "build-tools;26.0.1" && \

    echo "Install extra-android-m2repository" && \
    tools/bin/sdkmanager "extras;android;m2repository" && \

    echo "Install extra-google-google_play_services" && \
    tools/bin/sdkmanager "extras;google;google_play_services" && \

    echo "Install extra-google-m2repository" && \
    tools/bin/sdkmanager "extras;google;m2repository" && \

    echo "Install tools 26.0.2" && \
    tools/bin/sdkmanager "tools" && \

    echo "Install constraint layout 1.0.2" && \
    tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" && \
    tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"


# Add android commands to PATH
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1536m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

WORKDIR /project
