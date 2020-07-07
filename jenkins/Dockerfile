FROM jenkins/jenkins:lts

USER root

ENV DEBIAN_FRONTEND noninteractive

COPY trust_ca_certs.sh /tmp/
RUN bash -xc "bash /tmp/trust_ca_certs.sh"

RUN bash -xc "curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; apt-key fingerprint 0EBFCD88"

RUN bash -xc "apt-get update ; apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common"

RUN bash -xc 'add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"'

RUN bash -xc "apt-get update ; apt-get install -y man inotify-tools tmux vim curl tar wget unzip bash-completion git; apt-get update ; cp /usr/share/doc/tmux/examples/screen-keys.conf /etc/tmux.conf ; cp /usr/share/doc/tmux/examples/bash_completion_tmux.sh /etc/bash_completion.d/ ; echo 'source /etc/bash_completion' >> /root/.bashrc" 


RUN bash -xc "wget https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/ "
RUN bash -xc "apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose"
RUN bash -xc "adduser jenkins docker"
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JAVA_TOOL_OPTIONS -XX:+UseG1GC

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JENKINS_URL http://localhost:8080/jenkins
ENV JENKINS_OPTS "--prefix=/jenkins"

COPY scripts/ /usr/share/jenkins/ref/init.groovy.d/

COPY testing /var/testing
RUN bash -xc "cd /var/testing/ ; java SSLPoke www.google.com 443"

ARG DOCKER_GID=993
RUN bash -xc "addgroup --gid ${DOCKER_GID} docker_rh && adduser jenkins docker_rh"

USER jenkins
