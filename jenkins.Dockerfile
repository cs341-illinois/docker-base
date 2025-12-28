FROM jenkins/jenkins:2.543
ENV JAVA_OPTS="-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Chicago"
USER root
RUN apt-get -qq update \
    && apt-get -qq -y install \
    curl
RUN curl -sSL https://get.docker.com/ | sh
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow github ssh-slaves timestamper git role-strategy saml build-user-vars-plugin job-dsl pipeline-utility-steps pipeline-stage-view slack authorize-project PrioritySorter"
