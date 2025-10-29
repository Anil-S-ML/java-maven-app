pipeline {
    agent any

    stages {
        stage('Say Hello') {
            steps {
                echo 'Starting the application build process...'
                echo 'Hello from Jenkins! This is your application.'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
