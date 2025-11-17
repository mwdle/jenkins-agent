# Jenkins Agent (Custom)

A lightweight Jenkins agent image designed for use with the [Jenkins Docker Plugin](https://plugins.jenkins.io/docker-plugin/), preloaded with common DevOps tools for homelab automation and CI/CD pipelines.

[GitHub](https://github.com/mwdle/jenkins-agent)

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

    dockerTemplateBase:
      image: mwdle/jenkins-agent:latest
      connector:
        attach:
          user: jenkins

## Intended use

This image is built to support homelab automation and Jenkins pipelines that require:

- Running Docker builds inside agent containers (via Docker-out-of-Docker pattern)
- Access to Git, SSH, and Ansiblefor deployment/automation tasks

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Disclaimer

This repository and its contents are provided as-is for personal and educational use. The author assumes no responsibility for any errors, omissions, or consequences that may arise from the use of the information and scripts provided.
