pipeline {
  agent any

  environment {
    ANSIBLE_SERVER = '20.17.177.229'
  }

  stages {

    /* --------------------------------------------------------
     * 1️⃣ COPY FILES TO THE ANSIBLE CONTROL NODE
     * -------------------------------------------------------- */
    stage("Copy files to ansible server") {
      steps {
        script {
          echo "Copying all necessary files to Ansible control node..."

          sshagent(['ansible-server-key']) {

            // Copy all ansible files
            sh """
              scp -o StrictHostKeyChecking=no ansible/* \
              ansible@${ANSIBLE_SERVER}:/home/ansible
            """

            // Copy private key securely
            withCredentials([
              sshUserPrivateKey(
                credentialsId: 'ansible-server-key',
                keyFileVariable: 'KEYFILE'
              )
            ]) {
              sh """
                scp -o StrictHostKeyChecking=no ${KEYFILE} \
                ansible@${ANSIBLE_SERVER}:/home/ansible/ssh-key.pem
              """
              sh """
                ssh -o StrictHostKeyChecking=no ansible@${ANSIBLE_SERVER} \
                'chmod 600 /home/ansible/ssh-key.pem'
              """
            }

          } // end sshagent
        }
      }
    }

    /* --------------------------------------------------------
     * 2️⃣ RUN ANSIBLE PLAYBOOK
     * -------------------------------------------------------- */
    stage("Execute Ansible playbook") {
      steps {
        script {
          echo "Calling ansible playbook to configure EC2 instances..."

          def remote = [:]
          remote.name = "ansible-server"
          remote.host = "${ANSIBLE_SERVER}"
          remote.user = "ansible"
          remote.allowAnyHosts = true

          withCredentials([
            sshUserPrivateKey(
              credentialsId: 'ansible-server-key',
              keyFileVariable: 'ANSIBLE_KEY'
            )
          ]) {

            remote.identityFile = ANSIBLE_KEY

            sshCommand remote: remote, command: """
              cd /home/ansible &&
              ansible-playbook -i inventory_aws_ec2.yaml my-playbook.yaml -vv
            """
          }
        }
      }
    }

  } // end stages
} // end pipeline
