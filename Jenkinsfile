pipeline {
    agent any

    tools {
        // Use the Maven installation configured in Jenkins (name must match what you configured)
        maven 'maven-3.9'
    }

    stages {
        stage('Build') {
            steps {
                // 'mvn' now refers to Maven 3.9
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Deploying app..."'
                // Add your deployment commands here
            }
        }
    }
}
