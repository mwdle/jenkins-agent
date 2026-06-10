# Java base image allows Jenkins to use the Docker Plugin's `attach` connector and inject the jenkins agent jar at runtime - the only requirement is that Java is installed and accessible in the container
FROM eclipse-temurin:25.0.3_9-jre-noble@sha256:f9bd8815e73632c22985ebb133ec49b9fc4ad5ffe0657594ac02748ad0431ab7

ENV DEBIAN_FRONTEND=noninteractive \
    BUILDKIT_PROGRESS=plain

# https://bugs.launchpad.net/cloud-images/+bug/2005129
RUN userdel -r ubuntu && \
    apt-get update && apt-get install -y --no-install-recommends \
    ansible dnsutils curl ca-certificates git openssh-client sqlite3 unzip && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    docker-buildx-plugin docker-ce-cli docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

COPY --from=rclone/rclone:1.74.3@sha256:623378ad0ff3ebd5cebf77720843c0e02edfe46e2d5b5ac6bed54c6371780dfb /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=restic/restic:0.19.0@sha256:7f44e0057b82348597568ea209360762d0b38f8e1dbc8ad859661ac1055e45f2 /usr/bin/restic /usr/local/bin/restic
COPY --from=cupcakearmy/autorestic:1.8.3@sha256:0a826ea59ca452dadae50e618c0a14800450c920d22da0e35cb23e7a8be36d1f /usr/bin/autorestic /usr/local/bin/autorestic

RUN useradd --create-home --shell /bin/bash jenkins
USER jenkins
WORKDIR /home/jenkins

RUN ansible-galaxy collection install community.general