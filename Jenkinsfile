@Library("JenkinsPipelines") _ // See https://github.com/mwdle/JenkinsPipelines

dockerImagePipeline(
    defaultDockerCredentialsId: "Docker PAT",
    defaultImageName: 'mwdle/jenkins-agent',
    alertEmail: "${env.ALERT_EMAIL}"
)
