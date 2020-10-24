FROM ubuntu

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        automake \
        binutils \
        bison \
        cmake \
        curl \
        file \
        flex \
        g++ \
        gcc \
        git \
        lhasa \
        make \
        ninja-build \
        python3 \
        rsync \
        texinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists
