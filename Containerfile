FROM docker.io/jenkins/inbound-agent:3391.va_37fa_a_305d6d-5-jdk25@sha256:c14d4a30e370d3f950eff67b905f4d5e5f6c433aae214ff66d6331b8b1f37ca2

COPY --from=docker.io/aquasec/trivy:0.76.1@sha256:790fd66d1697395d8693d1acaa1ea702406a20f109b6fc7bac8db623eca6c06c /usr/local/bin/trivy /usr/local/bin/trivy

USER root

RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends podman-remote python3 python3-venv rsync
rm -rf /var/lib/apt/lists/*
EOF

USER jenkins

COPY --chown=jenkins:jenkins requirements.txt requirements.yaml ./

ENV PATH="/home/jenkins/.venv/bin:$PATH"

RUN <<EOF
set -e
python3 -m venv /home/jenkins/.venv
pip install --no-cache-dir -r requirements.txt
ansible-galaxy collection install -r requirements.yaml
rm requirements.txt requirements.yaml
EOF

# Override TZ defined in base image to allow local timezone instead of UTC
ENV TZ=:/etc/localtime