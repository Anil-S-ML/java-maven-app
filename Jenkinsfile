@Library('jenkins-shared-Library')_

pipeline {
    agent any

    tools {
        // Use the exact Maven tool name configured in Jenkins
        maven 'maven 3.9'
    }

    stages {

        stage('Build JAR') {
            steps {
                script {
                    echo "🏗️ Building the application with Maven..."
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo "🐳 Building and pushing Docker image..."

                    // Use Docker Hub credentials stored in Jenkins
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-repo',   // Jenkins credential ID for Docker Hub
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )]) {
                        sh '''
                            echo "🔧 Building Docker image..."
                            docker build -t anil2469/applisting:3.0 .

                            echo "🔑 Logging into Docker Hub..."
                            echo $PASS | docker login -u $USER --password-stdin

                            echo "📤 Pushing image to Docker Hub..."
                            docker push anil2469/applisting:3.0
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "🚀 Deploying the application..."
                    // Add deployment logic here if needed, e.g.:
                    // sh 'kubectl apply -f k8s/deployment.yaml'
                }
            }
        }
    }
}
}
