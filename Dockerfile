# Java base image allows Jenkins to use the Docker Plugin's `attach` connector and inject the jenkins agent jar at runtime - the only requirement is that Java is installed and accessible in the container
FROM eclipse-temurin:25.0.2_10-jre-noble@sha256:809fc6f4fd65745c943f82d36e6b15575986a9bea4b888fa03bec8d2353ea103

# https://bugs.launchpad.net/cloud-images/+bug/2005129
RUN userdel -r ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ansible \
    ca-certificates \
    curl \
    git \
    openssh-client \
    sqlite3 \
    unzip \
    && install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends \
    docker-buildx-plugin \
    docker-ce-cli \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

COPY --from=rclone/rclone:1.73.3@sha256:66af24d7c8809af336dc16068149257cf447c80f8c60aa9f5679153f42017b85 /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=restic/restic:0.18.1@sha256:39d9072fb5651c80d75c7a811612eb60b4c06b32ffe87c2e9f3c7222e1797e76 /usr/bin/restic /usr/local/bin/restic
COPY --from=cupcakearmy/autorestic:1.8.3@sha256:0a826ea59ca452dadae50e618c0a14800450c920d22da0e35cb23e7a8be36d1f /usr/bin/autorestic /usr/local/bin/autorestic

ENV BUILDKIT_PROGRESS=plain

RUN useradd --create-home --shell /bin/bash jenkins

USER jenkins

WORKDIR /home/jenkins

RUN ansible-galaxy collection install community.general