FROM docker.io/debian:stretch as build

ARG cores=4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       autoconf \
       automake \
       build-essential \
       ca-certificates \
       git \
       libtool \
       pkg-config \
    && rm -rfv /var/lib/apt/lists/*

FROM build as clustal

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libgomp1 \
       libargtable2-dev \
    && rm -rfv /var/lib/apt/lists/*

ADD . /clustal
WORKDIR /clustal

RUN ./configure --prefix=/usr/local --disable-dependency-tracking
RUN make -j$cores
RUN make -j$cores check
RUN make -j$cores install
RUN make -j$cores installcheck
RUN make -j$cores clean
