FROM jenkins/jenkins

USER root

# Install AWS CLI
RUN apt-get update && \
    apt-get install -y python3-pip
    
RUN apt-get update && apt-get install -y java-common libxml2-utils unzip zip curl git

RUN apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Install custom plugins
RUN jenkins-plugin-cli --plugins "kubernetes aws-credentials"

RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get install docker.io -y
RUN apt-get clean && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip
    
# Install JDK Corretto
RUN curl -o amazon-corretto-15.0.2.7.1-linux-x64.tar.gz https://corretto.aws/downloads/resources/15.0.2.7.1/amazon-corretto-15.0.2.7.1-linux-x64.tar.gz && \
    tar -xvzf amazon-corretto-15.0.2.7.1-linux-x64.tar.gz -C /tmp && ls -lrt /tmp && ls -la && cp -rf amazon-corretto-15.0.2.7.1-linux-x64 /tmp

ENV PATH="${PATH}:/tmp/amazon-corretto-15.0.2.7.1-linux-x64/bin"
ENV JAVA_HOME=/tmp/amazon-corretto-15.0.2.7.1-linux-x64

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip
    

## USER jenkins
