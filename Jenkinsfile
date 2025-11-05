// pipeline {
//     agent any

//     tools {
//         maven 'maven-3.9'
//     }

//     environment {
//         IMAGE_NAME = "anil2469/applisting:java-maven-1.0"
//     }

//     stages {

//         stage('Checkout Code') {
//             steps {
//                 checkout scm
//             }
//         }

//         stage('Build Application') {
//             steps {
//                 echo 'Building application JAR...'
//                 sh 'mvn clean package -DskipTests'
//             }
//         }

//         stage('Build and Push Docker Image') {
//             steps {
//                 script {
//                     echo 'Building and pushing Docker image...'
//                     withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'US', passwordVariable: 'PASS')]) {
//                         sh """
//                             docker build -t ${IMAGE_NAME} .
//                             echo \$PASS | docker login -u \$US --password-stdin
//                             docker push ${IMAGE_NAME}
//                         """
//                     }
//                 }
//             }
//         }

//         stage('Deploy to EC2') {
//             steps {
//                 script {
//                     echo 'Deploying Docker Compose to EC2...'
//                     def shellCmd = "bash ./server-cmnds.sh '${IMAGE_NAME}'"
//                     def ec2Instance = "ec2-user@15.207.19.151"

//                     sshagent(['ec2-server-key']) {
//                         sh """
//                             scp server-cmnds.sh ${ec2Instance}:/home/ec2-user/
//                             scp docker-compose.yml ${ec2Instance}:/home/ec2-user/
//                             ssh -o StrictHostKeyChecking=no ${ec2Instance} '${shellCmd}'
//                         """
//                     }
//                 }
//             }
//         }
//     }
// }
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
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
                sh 'kubectl create deployment mongo-deployment --image=mongo'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

