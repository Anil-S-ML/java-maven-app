pipeline {
    agent any

    tools {
        maven 'maven 3.9'
    }

    environment {
        // Base image name
        IMAGE_BASE = "anil2469/applisting"
    }

    stages {

        stage("Increment Version") {
            steps {
                script {
                    echo ' Incrementing app version...'
                    sh """
                        mvn build-helper:parse-version \
                            versions:set \
                            -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                            versions:commit
                    """

                    // Extract version from pom.xml
                    def matcher = readFile('pom.xml') =~ /<version>(.*)<\/version>/
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "${env.IMAGE_BASE}:${version}-${BUILD_NUMBER}"
                    echo "Docker image will be tagged as: ${env.IMAGE_NAME}"
                }
            }
        }

        stage("Build JAR") {
            steps {
                script {
                    echo 'Building the application with Maven...'
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo ' Building and pushing Docker image...'

                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-repo',
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )]) {
                        sh """
                          
                            docker build -t ${env.IMAGE_NAME} .

                            echo \$PASS | docker login -u \$USER --password-stdin

                            
                            docker push ${env.IMAGE_NAME}
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying the application....."
                    // Add deployment logic here, e.g.:
                    // sh 'kubectl apply -f k8s/deployment.yaml'
                }
            }
        }
    }
}
