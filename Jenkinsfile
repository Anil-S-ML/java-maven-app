pipeline {
    agent any

    tools {
        // Make sure this name matches your Jenkins > Global Tool Configuration
        maven 'maven-3.9'
    }

    stages {

        stage('Build JAR') {
            steps {
                script {
                    echo "🏗️ Building the application..."
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
                        credentialsId: 'docker-hub-repo',  // Jenkins credential ID
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
                    // Add your deployment logic here, e.g.:
                    // sh 'kubectl apply -f k8s/deployment.yaml'
                }
            }
        }
    }
}
