pipeline {
    agent any

    environment {
        IMAGE_NAME = "demo"
        DOCKERHUB_USER = "arulgun"
        DOCKER_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}"
    }

    stages {

        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/Arul-pro/Demo.git', branch: 'main'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    // SECURE way (NO Groovy interpolation)
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${GIT_COMMIT} .
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                    docker tag ${IMAGE_NAME}:${GIT_COMMIT} ${DOCKER_IMAGE}:${GIT_COMMIT}
                    docker tag ${DOCKER_IMAGE}:${GIT_COMMIT} ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push ${DOCKER_IMAGE}:${GIT_COMMIT}
                    docker push ${DOCKER_IMAGE}:latest
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
