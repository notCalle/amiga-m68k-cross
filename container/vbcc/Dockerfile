ARG IMAGE_TAG_PREFIX
ARG IMAGE_TAG_SUFFIX=latest
FROM ${IMAGE_TAG_PREFIX}/builder:${IMAGE_TAG_SUFFIX} AS builder
ARG PREFIX=/opt/amiga

ADD . /build
WORKDIR /build

RUN make LHA_OPTS=fq PREFIX=${PREFIX} install

FROM ubuntu
ARG PREFIX=/opt/amiga

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        curl\
        file \
        git \
        lhasa \
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

USER amiga
WORKDIR ${PREFIX}
ENV CC="vc -c99" \
    HOME=${PREFIX} \
    PATH=${PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash \
    VBCC=${PREFIX}/vbcc

COPY --from=builder ${PREFIX}/. ${PREFIX}/
