FROM docker.io/jenkins/inbound-agent:3391.va_37fa_a_305d6d-5-jdk25@sha256:c14d4a30e370d3f950eff67b905f4d5e5f6c433aae214ff66d6331b8b1f37ca2

USER root

RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    openssh-client \
    python3 \
    python3-venv \
    rsync \
    sqlite3 \
    unzip

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
tee /etc/apt/sources.list.d/docker.sources <<EOF_SOURCES
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF_SOURCES

apt-get update
apt-get install -y --no-install-recommends \
    docker-buildx-plugin \
    docker-ce-cli \
    docker-compose-plugin

rm -rf /var/lib/apt/lists/*
EOF

COPY --from=docker.io/aquasec/trivy:0.76.0@sha256:2416d1f74045b57274df1a340eee6b510cacd73c66a6ccb8da092b117eb7d222 /usr/local/bin/trivy /usr/local/bin/trivy
COPY --from=docker.io/rclone/rclone:1.75.2@sha256:2687085f718d3c628f7fdfb77c52a1d344332aed543110bb88088f2c70d43eb5 /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=docker.io/restic/restic:0.19.1@sha256:136600b6ff6843d61d355f7f71f460a166429f35de6fd11b568fece3c9a4d510 /usr/bin/restic /usr/local/bin/restic
COPY --from=docker.io/cupcakearmy/autorestic:1.8.3@sha256:0a826ea59ca452dadae50e618c0a14800450c920d22da0e35cb23e7a8be36d1f /usr/bin/autorestic /usr/local/bin/autorestic

USER jenkins
WORKDIR /home/jenkins

COPY --chown=jenkins:jenkins requirements.txt requirements.yaml ./

ENV PATH="/home/jenkins/.venv/bin:$PATH"

RUN python3 -m venv /home/jenkins/.venv && \
    pip install --no-cache-dir -r requirements.txt && \
    ansible-galaxy collection install -r requirements.yaml && \
    rm requirements.txt requirements.yaml
