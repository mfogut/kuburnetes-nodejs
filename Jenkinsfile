pipeline {
    agent any

    stages {
        stage('Build Docker image') {
            steps {
                sh "docker build -t . mfogut/nodeapp:v1" 
            }
        }
    }
}