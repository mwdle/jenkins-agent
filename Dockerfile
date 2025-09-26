# Java base image allows Jenkins to use the Docker Plugin's `attach` connector and inject the jenkins agent jar at runtime - the only requirement is that Java is installed and accessible in the container
# Available on Docker Hub as `mwdle/jenkins-agent:latest`
FROM eclipse-temurin:21-jre-jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends \
    docker-ce-cli \
    docker-compose-plugin \
    docker-buildx-plugin \
    git \
    openssh-client \
    ansible \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ENV BUILDKIT_PROGRESS=plain

RUN useradd --create-home --shell /bin/bash jenkins

USER jenkins

WORKDIR /home/jenkins