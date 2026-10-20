FROM docker.io/jenkins/inbound-agent:3391.va_37fa_a_305d6d-5-jdk25@sha256:c14d4a30e370d3f950eff67b905f4d5e5f6c433aae214ff66d6331b8b1f37ca2

COPY --from=docker.io/aquasec/trivy:0.76.0@sha256:2416d1f74045b57274df1a340eee6b510cacd73c66a6ccb8da092b117eb7d222 /usr/local/bin/trivy /usr/local/bin/trivy

USER root

RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends \
    podman-remote \
    python3 \
    python3-venv \
    rsync

rm -rf /var/lib/apt/lists/*
EOF

USER jenkins
WORKDIR /home/jenkins

COPY --chown=jenkins:jenkins requirements.txt requirements.yaml ./

ENV PATH="/home/jenkins/.venv/bin:$PATH"

RUN python3 -m venv /home/jenkins/.venv && \
    pip install --no-cache-dir -r requirements.txt && \
    ansible-galaxy collection install -r requirements.yaml && \
    rm requirements.txt requirements.yaml
