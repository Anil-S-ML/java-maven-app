
pipeline {
    agent any

    tools {
        maven 'maven-3.9'   // Make sure 'Maven' is configured in Jenkins global tools
    }

    environment {
        IMAGE_NAME = 'anil2469/applisting:java-maven-2.1'
    }

    stages {

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
                    echo 'Deploying Docker image to EC2...'
                    def dockerCmd = "docker run -p 3080:8080 -d ${IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@13.127.242.92 '${dockerCmd}'"
                    }
                }
            }
        }

    } 
}
