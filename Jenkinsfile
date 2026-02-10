pipeline {
    agent any

    environment {
        IMAGE_NAME = "demo"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/Arul-pro/Demo.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                printenv
                docker build -t ${IMAGE_NAME}:${GIT_COMMIT} .
                docker run -d  -it -p 8081:8081 --name ${IMAGE_NAME} ${IMAGE_NAME}:${GIT_COMMIT}
                '''
            }
        }
    }
}
