# Homelab Jenkins Agent

A custom Jenkins inbound agent image preloaded with common DevOps tools for
homelab automation and CI/CD pipelines. The same image supports ephemeral agents
launched through the Jenkins Docker Plugin and a permanent inbound agent managed
with Podman Quadlet.

## Features

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
- Python and a dedicated virtual environment for Ansible
- Configured `jenkins` user with home directory (`/home/jenkins`)

## Ephemeral agents

Use the image with the Docker Plugin's `attach` connector. The plugin starts a
temporary container, injects its Remoting JAR, runs one build, and removes the
container afterward.

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

## Permanent inbound agent

`jenkins-agent.container` runs a permanent, single-executor
inbound agent. Its independent lifecycle allows it to remain running while the
Jenkins controller is restarted or redeployed and reconnect afterward.

The Jenkins node name is derived from the host's systemd `%H` hostname specifier.
Create a matching permanent inbound node in Jenkins before starting the agent.
For example, a host named `lab` requires a Jenkins node named `lab`.

Store that node's inbound secret in the host's Podman secret store:

```bash
podman secret create jenkins_agent_secret /path/to/jenkins-agent-secret
```

The secret must exist before installing and starting `jenkins-agent.container`.
The Quadlet mounts it read-only for the `jenkins` user and passes its file path to
Jenkins Remoting; the secret is not placed directly in the unit or environment.
