# Flutter CI Docker image for local testing
# Replicates GitHub Actions ubuntu-latest with Flutter

FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter
ENV FLUTTER_VERSION=3.29.2
ENV FLUTTER_HOME=/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME} \
    && cd ${FLUTTER_HOME} \
    && git checkout ${FLUTTER_VERSION} \
    && flutter precache --web \
    && flutter config --no-analytics \
    && flutter doctor

# Set working directory
WORKDIR /app

# Default command
CMD ["flutter", "doctor"]
