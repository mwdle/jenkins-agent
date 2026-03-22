@Library("JenkinsPipelines") _ // See https://github.com/mwdle/JenkinsPipelines

dockerImagePipeline(
    defaultDockerCredentialsId: "Gitea PAT",
    defaultRegistryHost: "${env.CONTAINER_REGISTRY_HOST}",
    defaultImageName: 'lab/jenkins-agent',
    alertEmail: "${env.ALERT_EMAIL}"
)
