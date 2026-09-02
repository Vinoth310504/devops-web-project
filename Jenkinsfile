pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Git Status') {
            steps {
                sh 'git status'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t devops-web:latest .'
            }
        }

        stage('Stop Old Container') {
            steps {
                sh 'docker rm -f devops-web-container || true'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 80:80 --name devops-web-container devops-web:latest'
            }
        }

        stage('Verify') {
            steps {
                sh 'docker ps'
            }
        }
    }

    post {
        success {
            echo 'Website deployed successfully!'
        }

        failure {
            echo 'Deployment failed!'
        }
    }
}