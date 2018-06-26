FROM openjdk:10-jdk

ENV HOME /home/jenkins

RUN groupadd -g 10000 jenkins \
 && useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins

RUN apt-get update \
  && apt-get install -y git curl python3 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION=3.20
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY src/bin/ /usr/local/bin/
RUN chmod 775 /usr/local/bin/*

USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-slave.sh"]
