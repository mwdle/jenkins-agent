# Homelab Jenkins Agent

A custom Jenkins inbound agent image preloaded with common DevOps tools for homelab automation and CI/CD pipelines. The same image supports ephemeral agents launched through the Jenkins Docker Plugin and permanent inbound agents.

## Features

- **Docker tooling**:
  - `docker-buildx-plugin`
  - `docker-ce-cli`
  - `docker-compose-plugin`
- **Podman tooling**:
  - `podman-remote`
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
- Python and a dedicated virtual environment for Ansible
- Configured `jenkins` user with home directory (`/home/jenkins`)

## Ephemeral agents

Use the image with the Docker Plugin's `attach` connector. The plugin starts a temporary container, injects its Remoting JAR, runs one build, and removes the container afterward.

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

## Permanent inbound agents

A rootless Podman Quadlet configuration for permanent Jenkins agents is available separately in [jenkins-agent-config](https://github.com/mwdle/jenkins-agent-config).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
