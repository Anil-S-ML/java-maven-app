pipeline {
    agent any

    tools {
        maven 'maven-3.9' // Make sure this matches your Jenkins tool name
    }

    environment {
        IMAGE_NAME = "anil2469/applisting:jma-2.0"
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Use Jenkins credentials securely
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'US', passwordVariable: 'PASS')]) {
                        sh """
                            # Build Docker image
                            docker build -t $IMAGE_NAME .

                            # Login to Docker Hub
                            echo \$PASS | docker login -u \$US --password-stdin

                            # Push the image
                            docker push $IMAGE_NAME
                        """
                    }
                }
            }
        }
    }
}
