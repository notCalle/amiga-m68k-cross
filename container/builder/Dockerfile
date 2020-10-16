FROM ubuntu

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        automake \
        binutils \
        bison \
        cmake \
        file \
        flex \
        g++ \
        gcc \
        git \
        make \
        ninja-build \
        python3 \
        texinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists
