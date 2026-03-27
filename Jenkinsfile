@Library("JenkinsPipelines") _ // See https://github.com/mwdle/JenkinsPipelines

// Disable index triggers on branches that are not main/master
boolean isMainBranch = (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master')
boolean disableIndexTriggers = !isMainBranch

dockerImagePipeline(
    disableIndexTriggers: disableIndexTriggers,
    defaultDockerCredentialsId: "Gitea PAT",
    defaultRegistryHost: "${env.CONTAINER_REGISTRY_HOST}",
    defaultImageName: 'lab/jenkins-agent',
    alertEmail: "${env.ALERT_EMAIL}"
)
