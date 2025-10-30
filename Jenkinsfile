
pipeline {
    agent any

    tools {
        maven 'maven-3.9'   // Make sure 'Maven' is configured in Jenkins global tools
    }

    environment {
        IMAGE_NAME = 'anil2469/applisting:java-maven-3.0'
    }

    stages {
        stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                echo 'Building application JAR...'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'US', passwordVariable: 'PASS')]) {
                    sh """
                            # Build Docker image
                            docker build -t $IMAGE_NAME .

                            # Login to Docker Hub
                            echo $PASS | docker login -u $US --password-stdin

                            # Push the image
                            docker push $IMAGE_NAME
                        """
                    }

                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying Docker compose  to EC2...'
                    def dockerCmd = "docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yaml ec2-user@15.207.19.151:/home/ec2-user "
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@15.207.19.151 '${dockerCmd}'"
                    }
                }
            }
        }

    } 
}
