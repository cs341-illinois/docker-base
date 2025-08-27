FROM ubuntu:24.04

# Add the pinning configuration file
COPY apt_pins /etc/apt/preferences.d/build_tools_pins

# update sources and install prerequisites
RUN apt-get update && \
    apt-get install -y \
      software-properties-common \
      wget \
      bzip2

# install python and dev tools
RUN apt-get update && \
    apt-get install -y \
      python3.12 \
      python3-pip \
      python3.12-dev \
      cmake \
      iproute2 && \
    rm /usr/bin/python3 && \
    ln -s python3.12 /usr/bin/python3 && \
    ln -s -f /usr/lib/x86_64-linux-gnu/libc.a /usr/lib/x86_64-linux-gnu/liblibc.a

# install build-related tools and debug symbols using the defined pins
RUN apt-get update && \
    apt-get install -y \
        clang-18 \
        libncurses-dev \
        libncurses6 \
        rpcbind \
        git \
        strace \
        valgrind \
        libc6-dbg && \
    rm -rf /var/lib/apt/lists/*

# allow grader to find clang binary
RUN ln -s /usr/bin/clang-18 /usr/bin/clang || true
