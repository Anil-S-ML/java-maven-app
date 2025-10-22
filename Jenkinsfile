pipeline {
  agent any

  parameters {
    choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: 'Select the application version to build.')
    booleanParam(name: 'executeTests', defaultValue: true, description: 'Execute tests during the pipeline?')
  }

  stages {
    stage("Build") {
      steps {
        echo "Building the application version ${params.VERSION} ..."
      }
    }

    stage("Test") {
      when {
        expression { return params.executeTests }
      }
      steps {
        echo "Testing the application ..."
      }
    }

    stage("Deploy") {
      steps {
        echo "Deploying the application version ${params.VERSION} ..."
      }
    }
  }
}
