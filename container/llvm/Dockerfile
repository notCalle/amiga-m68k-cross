ARG IMAGE_TAG_PREFIX
ARG IMAGE_TAG_SUFFIX=latest
FROM ${IMAGE_TAG_PREFIX}/builder:${IMAGE_TAG_SUFFIX} AS builder
ARG PREFIX=/opt/amiga
ARG NINJA_FLAGS

RUN git clone \
        --branch release/13.x \
        --depth 1 \
        https://github.com/llvm/llvm-project.git \
        /build/deps/llvm-project


ADD . /build

RUN make -C /build NINJA_FLAGS="${NINJA_FLAGS}" PREFIX=${PREFIX} install-llvm

FROM ubuntu
ARG PREFIX=/opt/amiga
RUN yes | /usr/local/sbin/unminimize \
    && apt-get install -y \
        build-essential \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

COPY --from=builder ${PREFIX}/. ${PREFIX}/
