@Library("JenkinsPipelines") _ // See https://github.com/mwdle/JenkinsPipelines

// Disable index triggers on branches that are not main/master
boolean isMainBranch = (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master')
boolean disableIndexTriggers = !isMainBranch

dockerImagePipeline(
    disableIndexTriggers: disableIndexTriggers,
    defaultDockerCredentialsId: "Forgejo PAT",
    defaultRegistryHost: 'git.mwdle.com',
    defaultImageName: 'lab/jenkins-agent',
    alertEmail: "${env.ALERT_EMAIL}"
)
