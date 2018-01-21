FROM jenkins/jenkins:lts

USER root

RUN bash -xc "apt-get update ; apt-get install -y man inotify-tools tmux vim curl tar wget unzip bash-completion; apt-get update ; cp /usr/share/doc/tmux/examples/screen-keys.conf /etc/tmux.conf ; cp /usr/share/doc/tmux/examples/bash_completion_tmux.sh /etc/bash_completion.d/ ; echo 'source /etc/bash_completion' >> /root/.bashrc" 


COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JENKINS_URL http://localhost:8080

COPY scripts/ /usr/share/jenkins/ref/init.groovy.d/

USER jenkins

