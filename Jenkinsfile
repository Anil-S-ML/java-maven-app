pipeline {
    agent any

    tools {
        maven 'maven-3.9'
    }

    environment {
        IMAGE_NAME = "anil2469/applisting:java-maven-1.0"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                echo 'Building application JAR...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    echo 'Building and pushing Docker image...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'US', passwordVariable: 'PASS')]) {
                        sh """
                            docker build -t ${IMAGE_NAME} .
                            echo \$PASS | docker login -u \$US --password-stdin
                            docker push ${IMAGE_NAME}
                        """
                    }
                }
            }
        }

         stage('Deploy') {
            environment{
                AWS_ACCESS_KEY  = credentials('	jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY  = credentials('jenkins_aws_secret_access_key')
            }
            steps {
                script {
                echo 'Deploying the application...'
                sh 'envsubst <kubernetes/deployment.yaml |  kubectl -f - '
                sh 'envsubst <kubernetes/service.yaml |  kubectl -f - '
                }
            }
        } 
    }
}
