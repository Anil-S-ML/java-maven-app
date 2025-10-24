//@Library('jenkins-shared-Library') _

pipeline {
    agent any

    tools {
        // Use the exact Maven tool name configured in Jenkins
        maven 'maven 3.9'
    }

    stages {

        stage("increment version") {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion} versions:commit'
                    def matcher = readFile('pom.xml') =~ /<version>(.*)<\/version>/
                    def version = matcher[0][1]
                    env.IMAGE_NAME = env.IMAGE_NAME + "$version-$buildNumber"
                }
            }
        }


        stage("build jar") {
            steps {
                script {
                    echo "building the application..."
                    sh 'mvn clean package'
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
                        sh ''
                            "docker build -t anil2469/applisting:${IMAGE_NAME} . "

                            echo $PASS | docker login -u $USER --password-stdin

                            " docker push ${IMAGE_NAME} "
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "🚀 Deploying the application..."
                    echo "🚀 Deploying the integration"
                    // Add deployment logic here if needed, e.g.:
                    // sh 'kubectl apply -f k8s/deployment.yaml'
                }
            }
        }
    }
}
