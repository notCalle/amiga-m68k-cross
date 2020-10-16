ARG IMAGE_TAG_PREFIX
ARG IMAGE_TAG_SUFFIX=latest
FROM ${IMAGE_TAG_PREFIX}/builder:${IMAGE_TAG_SUFFIX} AS builder
ARG PREFIX=/opt/amiga

RUN git clone \
        --branch binutils-2_35-branch \
        --depth 1 \
        https://sourceware.org/git/binutils-gdb.git \
         /build/deps/binutils-gdb


ADD . /build

RUN make -C /build PREFIX=${PREFIX} install-binutils

FROM scratch
ARG PREFIX=/opt/amiga
COPY --from=builder ${PREFIX}/. ${PREFIX}/
