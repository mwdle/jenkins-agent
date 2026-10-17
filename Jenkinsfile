@Library("JenkinsPipelines") _ // See https://github.com/mwdle/JenkinsPipelines

boolean disableIndexTriggers = env.BRANCH_NAME != 'main'

containerImagePipeline(
    disableIndexTriggers: disableIndexTriggers,
    defaultImageName: 'lab/jenkins-agent'
)
