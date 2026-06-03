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

COPY --from=rclone/rclone:1.74.2@sha256:9ce0d49b611d3781233e25334e9e23d7af01e5546da7087f90d55f034ef13637 /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=restic/restic:0.18.1@sha256:39d9072fb5651c80d75c7a811612eb60b4c06b32ffe87c2e9f3c7222e1797e76 /usr/bin/restic /usr/local/bin/restic
COPY --from=cupcakearmy/autorestic:1.8.3@sha256:0a826ea59ca452dadae50e618c0a14800450c920d22da0e35cb23e7a8be36d1f /usr/bin/autorestic /usr/local/bin/autorestic

RUN useradd --create-home --shell /bin/bash jenkins
USER jenkins
WORKDIR /home/jenkins

RUN ansible-galaxy collection install community.general