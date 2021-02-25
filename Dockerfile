# Build ZeroTier -----------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM lsiodev/ubuntu:focal as zerotier
ARG ZeroTier

RUN apt-get update -y && apt-get install -y git make gcc g++
RUN git clone https://github.com/zerotier/ZeroTierOne /src
WORKDIR /src

RUN commit="$(git log ${ZeroTier} -n1 | head -1 | cut -d ' ' -f 2)" \
    git reset --quiet --hard ${commit}
RUN make -f make-linux.mk
RUN chmod +x zerotier-one

# Build CoreDNS ------------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM lsiodev/ubuntu:focal as coredns
ARG CoreDNS

RUN apt-get update -y && apt-get install -y git make golang
RUN git clone https://github.com/coredns/coredns /src
WORKDIR /src

RUN commit="$(git log ${CoreDNS} -n1 | head -1 | cut -d ' ' -f 2)" \
    git reset --quiet --hard ${commit}
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
LABEL vCoreDNS="${CoreDNS}"
LABEL vZeroDNS="${ZeroDNS}"
LABEL vZeroTier="${ZeroTier}"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# add local files
COPY root/ /
COPY --from=zerotier /src/zerotier-one /usr/sbin/
COPY --from=coredns /src/coredns /usr/bin/

# add dependencies (this bloats the image quite a bit)
RUN    echo "*** install ZeroDNS ***" \
    && apt-get update -y \
    && apt-get install -y ca-certificates python3 python3-pip npm nodejs iputils-ping net-tools \
    && pip3 install -r /app/requirements.txt \
    && npm install -g @laduke/zerotier-central-cli

RUN    mkdir -p /var/lib/zerotier-one \
    && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool \
    && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

# cleanup installation artifacts
RUN    echo "*** cleanup ***" \
    && apt-get clean \
    && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*


# ports and volumes
EXPOSE 5053 5053/udp
VOLUME /config