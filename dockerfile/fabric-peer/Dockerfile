FROM hyperledger/fabric-peer:x86_64-1.1.0
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

COPY sources.list /etc/apt/
RUN apt-get update && apt-get install -y --no-install-recommends net-tools iputils-ping tcpdump lsof lrzsz ifstat iftop sysstat vim-tiny
