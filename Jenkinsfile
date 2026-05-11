/*
pipeline {
    agent any

    options { 
       buildDiscarder(logRotator(numToKeepStr: '10')) 
       timestamps()
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh "docker build --no-cache -t python-app:v${BUILD_NUMBER} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                }
            }
        }

        stage('Tag Image') {
            steps {
                sh "docker tag python-app:v${BUILD_NUMBER} vineethmathangi95/python:hms-v${BUILD_NUMBER}"
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push vineethmathangi95/python:hms-v${BUILD_NUMBER}"
            }
        }
    }
}
*/
pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REGISTRY = "240029899648.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPOSITORY = "python"
        IMAGE_NAME = "python-app"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build --no-cache -t ${IMAGE_NAME}:v${BUILD_NUMBER} .
                """
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    export AWS_DEFAULT_REGION=${AWS_REGION}

                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    """
                }
            }
        }

        stage('Tag Image') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:v${BUILD_NUMBER} \
                ${ECR_REGISTRY}/${ECR_REPOSITORY}:hms-v${BUILD_NUMBER}
                """
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh """
                docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:hms-v${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Image successfully pushed to ECR!"
        }

        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
