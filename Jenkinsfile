@Library('jenkins-shared-library@master') _

pipeline {
    agent any

    tools {
        maven 'maven 3.9'   // Make sure 'Maven' is configured in Jenkins global tools
    }

    environment {
        IMAGE_NAME = 'anil2469/applisting:java-maven-1.0'
    }

    stages {

        stage('Build Application') {
            steps {
                echo 'Building application JAR...'
                buildJar()  // assumes buildJar() is defined in your shared library
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    buildImage(env.IMAGE_NAME)   // buildImage() from shared library
                    dockerLogin()                // login to Docker registry
                    dockerPush(env.IMAGE_NAME)  // push image to Docker registry
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying Docker image to EC2...'
                    def dockerCmd = "docker run -p 3080:3080 -d ${IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.184.54.160 '${dockerCmd}'"
                    }
                }
            }
        }

    } // end stages
}
