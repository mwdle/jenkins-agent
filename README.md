# Homelab Jenkins Agent

A lightweight Jenkins agent image preloaded with common DevOps tools for homelab automation and CI/CD pipelines.

## Table of Contents

- [Features](#features)
- [Usage](#usage)
- [Intended use](#intended-use)
- [License](#license)
- [Disclaimer](#disclaimer)

## Features

- **Base:** [`eclipse-temurin:21-jre-jammy`](https://hub.docker.com/_/eclipse-temurin) (Java 21 JRE, Ubuntu Jammy)
- **Docker tooling**:
  - `docker-ce-cli`
  - `docker-compose-plugin`
  - `docker-buildx-plugin`
- **DevOps utilities**:
  - `git`
  - `openssh-client`
  - `ansible`
  - `unzip`
- Configured `jenkins` user with home directory (`/home/jenkins`)

## Usage

Use in your Jenkins Docker cloud agent template configuration:

```yaml
# JCasC Example
jenkins:
  # ...
  clouds:
    - docker:
        # ...
        templates:
          - connector:
              attach:
            dockerTemplateBase:
              image: mwdle/jenkins-agent:latest # https://hub.docker.com/repository/docker/mwdle/jenkins-agent/general
```

## Intended use

This image is built to support homelab automation and Jenkins pipelines for:

- Running Docker builds and inside agent containers (via Docker-out-of-Docker pattern)
- Access to
  - Git
  - SSH
  - Docker Compose
  - Ansible

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Disclaimer

This repository and its contents are provided as-is for personal and educational use. The author assumes no responsibility for any errors, omissions, or consequences that may arise from the use of the information and scripts provided.
