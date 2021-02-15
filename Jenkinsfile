pipeline {
    agent any
    enviroment {
        DOCKER_TAG = getDockerTag()
    }
    stages {
        stage('Build Docker image') {
            steps {
                sh "docker build -t mfogut/nodeapp:${DOCKER_TAG} ." 
            }
        }
    }
}

def getDockerTag() {
    def tag = sh script : "git rev-parse HEAD", returnStdout: true
    return tag
}