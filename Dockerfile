FROM ubuntu:24.04

# Add the pinning configuration file
COPY apt_pins /etc/apt/preferences.d/build_tools_pins

# No longer need "ARG TARGETARCH"

# Install all packages, create symlinks, and clean up in a single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3-pip \
      python3.12 \
      cmake \
      clang-18 \
      valgrind \
      libc6-dbg && \
    #
    # Configure symlinks
    #
    rm -f /usr/bin/python3 && \
    ln -s python3.12 /usr/bin/python3 && \
    #
    # Create architecture-specific symlink for libc.a
    #
    BUILD_ARCH=$(dpkg --print-architecture) && \
    case ${BUILD_ARCH} in \
        "amd64") \
            ln -s -f /usr/lib/x86_64-linux-gnu/libc.a /usr/lib/x86_64-linux-gnu/liblibc.a ;; \
        "arm64") \
            ln -s -f /usr/lib/aarch64-linux-gnu/libc.a /usr/lib/aarch64-linux-gnu/liblibc.a ;; \
        *) \
            echo "Unsupported architecture: ${BUILD_ARCH}" && exit 1 ;; \
    esac && \
    #
    # Clean up apt cache
    #
    rm -rf /var/lib/apt/lists/*

# Allow grader to find clang binary
RUN ln -s /usr/bin/clang-18 /usr/bin/clang || true