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
