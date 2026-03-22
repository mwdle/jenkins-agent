# Java base image allows Jenkins to use the Docker Plugin's `attach` connector and inject the jenkins agent jar at runtime - the only requirement is that Java is installed and accessible in the container
FROM eclipse-temurin:25-jre-noble

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

COPY --from=rclone/rclone:latest /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=restic/restic:latest /usr/bin/restic /usr/local/bin/restic
COPY --from=cupcakearmy/autorestic:latest /usr/bin/autorestic /usr/local/bin/autorestic

ENV BUILDKIT_PROGRESS=plain

RUN useradd --create-home --shell /bin/bash jenkins

USER jenkins

WORKDIR /home/jenkins

RUN ansible-galaxy collection install community.general