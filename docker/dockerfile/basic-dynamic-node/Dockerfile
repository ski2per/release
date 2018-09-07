FROM openjdk:8-jdk-slim
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

COPY sources.list /etc/apt/
RUN apt-get update && apt-get install -y --no-install-recommends openssh-server git gcc g++ make

RUN mkdir /var/run/sshd

RUN sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
RUN sed -i '/UseDNS/d' /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "UseDNS no" >> /etc/ssh/sshd_config

RUN echo 'root:P@ssw0rd' | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
