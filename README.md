# Homelab Jenkins Agent

A custom Jenkins inbound agent image optimized for homelab automation and CI/CD pipelines.

## Core Capabilities

- **Configuration Management:** Dedicated Python virtual environment preloaded with Ansible.
- **Container Tooling:** Podman remote client.
- **Security Scanning:** Trivy integrated for container and filesystem vulnerability checks.
- **Pipeline Utilities:** Standard build and deployment tools included by default (git, ssh, rsync).

## Usage

This image supports both ephemeral and permanent agent deployment models.

### Ephemeral Agents (Jenkins Docker Plugin)

To use as an ephemeral agent, configure a Docker agent template via JCasC or the Jenkins UI with these settings:

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

### Permanent Inbound Agents

For permanent agents containers, a plug-and-play Podman Quadlet configuration is available in the [jenkins-agent-config](https://github.com/mwdle/jenkins-agent-config) repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
