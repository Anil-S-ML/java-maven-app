pipeline {
    agent any

    tools {
        maven 'maven-3.9'   // Make sure "maven-3.9" is configured in Jenkins Global Tools
    }

    stages {

        stage('Build JAR') {
            steps {
                script {
                    echo "🏗️  Building the application..."
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building the Docker image..."

                    // Use Docker Hub credentials stored in Jenkins
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-repo',   // <-- Your Jenkins credentials ID
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )]) {
                        // Replace the repo name below with YOUR Docker Hub repository
                        sh '''
                            docker build -t anil2469/applisting:3.0 .
                            echo $PASS | docker login -u $US --password-stdin 
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
                    // You can add your deployment commands here, e.g.:
                    // sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}
