//@Library('jenkins-shared-Library') _

pipeline {
    agent any

    tools {
        // Use the exact Maven tool name configured in Jenkins
        maven 'maven 3.9'
    }

    environment {
        IMAGE_NAME = "anil2469/applisting:"
    }

    stages {

        stage("Increment Version") {
            steps {
                script {
                    echo 'Incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set -DnewVersion=${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion} versions:commit'
                    def matcher = readFile('pom.xml') =~ /<version>(.*)<\/version>/
                    def version = matcher[0][1]
                    env.IMAGE_NAME = env.IMAGE_NAME + "${version}-${BUILD_NUMBER}"
                }
            }
        }

        stage("Build JAR") {
            steps {
                script {
                    echo "Building the application..."
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo "🐳 Building and pushing Docker image..."
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-repo',   // Jenkins credential ID for Docker Hub
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )]) {
                        sh '''
                            docker build -t ${IMAGE_NAME} .
                            echo $PASS | docker login -u $USER --password-stdin
                            docker push ${IMAGE_NAME}
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
