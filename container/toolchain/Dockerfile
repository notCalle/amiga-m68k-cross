ARG IMAGE_TAG_PREFIX
ARG IMAGE_TAG_SUFFIX=latest
FROM ${IMAGE_TAG_PREFIX}/binutils:${IMAGE_TAG_SUFFIX} AS binutils
FROM ${IMAGE_TAG_PREFIX}/llvm:${IMAGE_TAG_SUFFIX} AS llvm
FROM ${IMAGE_TAG_PREFIX}/vbcc-xdk:${IMAGE_TAG_SUFFIX} AS vbcc

FROM ubuntu
ARG PREFIX=/opt/amiga

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        file \
        git \
        make \
        tmux \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists \
    && useradd \
        --comment "Amiga Coder" \
        --create-home \
        --home-dir $PREFIX \
        --shell /bin/bash \
        --uid 10000 \
        --user-group \
        amiga

COPY --from=binutils ${PREFIX}/. ${PREFIX}/
COPY --from=llvm ${PREFIX}/. ${PREFIX}/
COPY --from=vbcc ${PREFIX}/. ${PREFIX}/

USER amiga
WORKDIR /opt/amiga
ENV HOME=/opt/amiga \
    PATH=/opt/amiga/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash
