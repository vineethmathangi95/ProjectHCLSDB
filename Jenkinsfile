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
        ECR_REPO = "240029899648.dkr.ecr.us-east-1.amazonaws.com/python"
        IMAGE_NAME = "python-app"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh "docker build --no-cache -t ${IMAGE_NAME}:v${BUILD_NUMBER} ."
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ECR_REPO}
                """
            }
        }

        stage('Tag Image for ECR') {
            steps {
                sh "docker tag ${IMAGE_NAME}:v${BUILD_NUMBER} ${ECR_REPO}:hms-v${BUILD_NUMBER}"
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh "docker push ${ECR_REPO}:hms-v${BUILD_NUMBER}"
            }
        }
    }
}
