# Homelab Jenkins Agent

A custom Jenkins agent Docker image preloaded with common DevOps tools for homelab automation and CI/CD pipelines.

## Features

- **Base:** [`eclipse-temurin:25-jre-noble`](https://hub.docker.com/_/eclipse-temurin)
- **Docker tooling**:
  - `docker-buildx-plugin`
  - `docker-ce-cli`
  - `docker-compose-plugin`
- **DevOps utilities**:
  - `ansible-core`
  - `autorestic`
  - `curl`
  - `git`
  - `openssh-client`
  - `rclone`
  - `restic`
  - `trivy`
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
                user: "jenkins" # Assumes the agent should run as user `jenkins`
            dockerTemplateBase:
              image: your-container-registry.com/lab/jenkins-agent:latest
```
