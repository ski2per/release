FROM openjdk:8-jdk-slim
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

# Setup SSH server
#COPY sources.list /etc/apt/sources.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y openssh-server curl
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#UseDNS.*/UseDNS no/' \
        -e 's/#PermitRootLogin.*/PermitRootLogin yes/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication yes/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd

# Change password for root and jenkins
RUN echo 'jenkins:jenkins' | chpasswd
RUN echo 'root:P@ssw0rd' | chpasswd

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

# Setup Docker via official script
RUN curl -fsSL get.docker.com | sh

RUN usermod -aG docker jenkins

# Remove apt cache
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

