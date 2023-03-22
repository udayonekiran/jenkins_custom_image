FROM jenkins/jenkins:lts

USER root

# Install AWS CLI
RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip3 install awscli
    
RUN apt-get update && apt-get install -y java-common libxml2-utils unzip zip curl git && apt-get clean && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Install JDK Corretto
RUN curl -o amazon-corretto-15.0.2.7.1-linux-x64.tar.gz https://corretto.aws/downloads/resources/15.0.2.7.1/amazon-corretto-15.0.2.7.1-linux-x64.tar.gz && \
    tar -xvzf amazon-corretto-15.0.2.7.1-linux-x64.tar.gz -C /tmp

# Install custom plugins
# RUN jenkins-plugin-cli --plugins "snyk-security-scanner:2.12.1 file-operations:1.11 branch-api:2.5.6 pipeline-build-step:2.13 workflow-support:3.8 aws-credentials:1.28 subversion:2.13.1 github-branch-source:2.7.1 publish-over-ftp:1.15 cloudbees-folder:6.740.ve4f4ffa_dea_54"

# Set environment variables
# ENV <ENV_VARIABLE_1> <VALUE>
# ENV <ENV_VARIABLE_2> <VALUE>
ENV PATH="${PATH}:/tmp/amazon-corretto-15.0.2.7.1-linux-x64/bin"
ENV JAVA_HOME=/tmp/amazon-corretto-15.0.2.7.1-linux-x64

USER jenkins
