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
          sshagent(['ansible-server-key']) {
            sh "scp -o StrictHostKeyChecking=no ansible/* ansible@${ANSIBLE_SERVER}:/home/ansible"
          }

          withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key-1', keyFileVariable: 'KEYFILE', usernameVariable:'user')]) {
            sh 'scp /home/anil_kumar/.ssh/ansible-jenkins.pem ansible@${ANSIBLE_SERVER}:/home/ansible/ssh-key.pem'
          }
        }
      }
    }

    // If you want to keep the second stage commented, do NOT leave extra braces
    // stage("execute ansible playbook") {
    //   steps {
    //     script {
    //       echo "calling ansible playbook to configure ec2 instances"
    //       def remote = [:]
    //       remote.name = "ansible-server"
    //       remote.host = "${ANSIBLE_SERVER}"
    //       remote.user = "ansible"
    //       remote.allowAnyHosts = true
    //
    //       withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'ANSIBLE_KEY')]) {
    //         remote.identityFile = ANSIBLE_KEY
    //         sshCommand remote: remote, command: "ls -l"
    //       }
    //     }
    //   }
    // }
  } // closes stages
} // closes pipeline
