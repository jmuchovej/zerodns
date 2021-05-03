# Build ZeroTier -----------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM lsiodev/ubuntu:focal as zerotier

COPY ZeroTier/ /src
WORKDIR /src

RUN apt-get update -y && apt-get install -y make gcc g++

RUN make -f make-linux.mk
RUN chmod +x zerotier-one

# Build CoreDNS ------------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM lsiodev/ubuntu:focal as coredns

COPY CoreDNS/ /src
WORKDIR /src

RUN apt-get update -y && apt-get install -y make golang

RUN make
RUN chmod +x coredns

# Setup ZeroDNS ------------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM lsiodev/ubuntu:focal as zerodns

# set version label
ARG BUILD_DATE
ARG ZeroDNS
ARG CoreDNS
ARG ZeroTier
LABEL build_version="ZeroDNS version:- ${ZeroDNS} Build-date:- ${BUILD_DATE}"
LABEL maintainer="jmuchovej"
LABEL CoreDNS="${CoreDNS}"
LABEL ZeroDNS="${ZeroDNS}"
LABEL ZeroTier="${ZeroTier}"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# add local files
COPY root/ /
COPY --from=zerotier /src/zerotier-one /usr/sbin/
COPY --from=coredns /src/coredns /usr/bin/

RUN    mkdir -p /var/lib/zerotier-one \
    && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool \
    && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

# add dependencies (this bloats the image quite a bit)
RUN    echo "*** install apt-dependencies for ZeroDNS ***" \
    && apt-get update -y \
    && apt-get install -y ca-certificates python3 python3-pip npm nodejs iputils-ping net-tools libcap-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN    echo "*** install ZeroDNS ***" \
    && pip3 install -r /app/requirements.txt \
    && npm install -g @laduke/zerotier-central-cli \
    && rm -rf /tmp/* /var/tmp/*

# ports and volumes
EXPOSE 5353 5353/udp
VOLUME /config

