pipeline {
    agent any

    environment {
        IMAGE_NAME = "demo"
        DOCKERHUB_USER = "arulgun"
        // Using lazy evaluation to ensure variables are populated
        DOCKER_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}"
    }

    stages {
        stage('Git Checkout') {
            steps {
                // Ensure the branch matches your repo (main vs master)
                git url: 'https://github.com/Arul-pro/Demo.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Using double quotes so Jenkins can inject ${IMAGE_NAME} and ${GIT_COMMIT}
                    sh "docker build -t ${IMAGE_NAME}:${GIT_COMMIT} ."
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${GIT_COMMIT} ${DOCKER_IMAGE}:${GIT_COMMIT}
                docker tag ${IMAGE_NAME}:${GIT_COMMIT} ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Login to Docker Hub') {
            steps {
                // IMPORTANT: Ensure 'dockerhub-cred' is the EXACT ID you created in Jenkins Credentials
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred', 
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                docker push ${DOCKER_IMAGE}:${GIT_COMMIT}
                docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
    }

    post {
        always {
            // Clean up by logging out and removing local images to save space
            sh "docker logout"
        }
        failure {
            echo "Pipeline failed. Check the Docker Hub credentials or network connectivity."
        }
    }
}
