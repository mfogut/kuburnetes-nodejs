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
        stage("Deploy to Kuburnetes") {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['ssh-agent']) {
                    sh "scp -o StrictHostKeyChecking=no nodejs-service.yml node-app-pod.yml ec2-user@54.157.164.116:/home/ec2-user/"
                    script {
                        try {
                            sh "ssh ec2-user@54.157.164.116 kubectl apply -f ."
                        }
                        catch(error) {
                            sh "ssh ec2-user@54.157.164.116 kubectl apply -f ."
                        }
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