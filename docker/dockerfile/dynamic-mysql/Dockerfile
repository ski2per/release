FROM mysql:5.7
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

COPY sources.list /etc/apt/
RUN apt-get update && apt-get install -y --no-install-recommends openssh-server git default-jre default-jdk

RUN mkdir /var/run/sshd && \
    sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config && \
    sed -i '/UseDNS/d' /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "UseDNS no" >> /etc/ssh/sshd_config && \
    echo 'root:P@ssw0rd' | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
