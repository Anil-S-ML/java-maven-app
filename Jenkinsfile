pipeline {
    agent any

    tools {
        maven 'maven-3.9'
    }

    environment {
        IMAGE_NAME = "java-maven-1.0"
        DOCKER_REPO_SERVER = '004380138556.dkr.ecr.us-east-1.amazonaws.com'
        DOCKER_REPO = "${DOCKER_REPO_SERVER}/java-maven-app"
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
                    withAWS(credentials: 'ecr-credentials', region: 'us-east-1') {
                        sh """
                            docker build -t ${DOCKER_REPO}:${IMAGE_NAME} .
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${DOCKER_REPO_SERVER}
                            docker push ${DOCKER_REPO}:${IMAGE_NAME}
                        """
                    }
                }
            }
        }

        stage('Provision Server') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script {
                    dir('terraform') {
                        sh '''
                            rm -rf .terraform* terraform.tfstate*
                            terraform init -reconfigure
                            terraform destroy --auto-approve || true
                            terraform apply --auto-approve
                        '''
                        env.EC2_PUBLIC_IP = sh(
                            script: "terraform output aws_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Waiting for EC2 server to initialize..."
                    sleep(time: 90, unit: "SECONDS")

                    echo "EC2 Public IP: ${env.EC2_PUBLIC_IP}"
                    echo '🚀 Deploying Docker image to EC2...'

                    def ec2Instance = "ec2-user@${env.EC2_PUBLIC_IP}"
                    def shellCmd = "bash /home/ec2-user/server-cmnds.sh ${IMAGE_NAME}"

                    sshagent(['server-ssh-key']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmnds.sh ${ec2Instance}:/home/ec2-user/"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${ec2Instance}:/home/ec2-user/"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} '${shellCmd}'"
                    }
                    
                    echo "🎉 Deployment completed successfully on ${env.EC2_PUBLIC_IP}"
                    echo "🌐 Access your app at: http://${env.EC2_PUBLIC_IP}:8080"
                }
            }
        }
    }
}
