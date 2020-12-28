FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUIL_DATE
ARG ZeroDNS
ARG CoreDNS
ARG CoreDNSpkg
LABEL build_version="DNS.zt version:- ${ZeroDNS} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ionlights"
LABEL vCoreDNS="${CoreDNS}"
LABEL vZeroDNS="${ZeroDNS}"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

# add dependencies
RUN echo "*** install packages ***" && \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        python3 \
        python3-pip

# install CoreDNS
RUN echo "*** install CoreDNS ***" && \
    curl -fsSL ${CoreDNSpkg} -o /tmp/coredns.tgz && \
    tar -xzf /tmp/coredns.tgz && \
    mv coredns /usr/bin/coredns && \
    chmod +x /usr/bin/coredns

# install Invoke
COPY requirements.txt /tmp
RUN echo "*** install Invoke ***" && \
    pip3 install -r /tmp/requirements.txt

RUN echo "*** cleanup ***" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 53 53/udp
VOLUME /config