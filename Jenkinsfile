pipeline {
    agent any
    environment {
        DOCKER_TAG = getDockerTag()
        registry = "mfogut/nodeapp"
        registryCredential = 'dockerhub'
    }
    stages {
        stage('Build Docker image') {
            steps {
                sh "docker build . -t mfogut/nodeapp:${DOCKER_TAG}" 
            }
        }
        stage("DockerHub Push Image") {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                    sh "docker push mfogut/nodeapp:${DOCKER_TAG}"
                    }
                }
            }
        }
    }
}

def getDockerTag() {
    def tag = sh script : "git rev-parse HEAD", returnStdout: true
    return tag
}