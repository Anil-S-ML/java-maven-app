pipeline {
  agent any

  environment {
    ANSIBLE_SERVER = '20.17.177.229'
  }

  stages {
    stage("Copy files to ansible server") {
      steps {
        script {
          echo "copying all necessary files to ansible control node"

          // Use ansible-server-key for everything
          sshagent(['ansible-server-key']) {

            // 1️⃣ Copy all ansible files
            sh "scp -o StrictHostKeyChecking=no ansible/* ansible@${ANSIBLE_SERVER}:/home/ansible"

            // 2️⃣ Copy private key (use same working key)
            withCredentials([
              sshUserPrivateKey(
                credentialsId: 'ansible-server-key',
                keyFileVariable: 'KEYFILE'
              )
            ]) {
              sh "scp -o StrictHostKeyChecking=no ${KEYFILE} ansible@${ANSIBLE_SERVER}:/home/ansible/ssh-key.pem"
              sh "ssh -o StrictHostKeyChecking=no ansible@${ANSIBLE_SERVER} 'chmod 600 /home/ansible/ssh-key.pem'"
            }

          } // end sshagent
        }
      }
    }
  }
}
