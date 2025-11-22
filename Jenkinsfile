pipeline {
    agent any

    environment {
        ANSIBLE_SERVER = '20.17.177.229'
        ANSIBLE_USER = 'ansible'
    }

    stages {

        stage("Copy files to Ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to Ansible control node..."

                    // Step 1: Copy playbook files using Ansible server key
                    sshagent(['ansible-server-key']) {
                        sh """
                            scp -o StrictHostKeyChecking=no ansible/* ${ANSIBLE_USER}@${ANSIBLE_SERVER}:/home/${ANSIBLE_USER}/
                        """
                    }

                    // Step 2: Copy EC2 private key to Ansible server
                    withCredentials([
                        sshUserPrivateKey(
                            credentialsId: 'ec2-server-key',
                            keyFileVariable: 'KEYFILE'
                        )
                    ]) {
                        sshagent(['ansible-server-key']) {
                            sh """
                                scp -o StrictHostKeyChecking=no ${KEYFILE} ${ANSIBLE_USER}@${ANSIBLE_SERVER}:/home/${ANSIBLE_USER}/ssh-key.pem
                            """
                        }
                    }
                }
            }
        }

    //     stage("Run Ansible playbook") {
    //         steps {
    //             script {
    //                 echo "Running Ansible playbook on Ansible server..."

    //                 def remote = [:]
    //                 remote.name = "ansible-server"
    //                 remote.host = "${ANSIBLE_SERVER}"
    //                 remote.user = "${ANSIBLE_USER}"
    //                 remote.allowAnyHosts = true

    //                 withCredentials([
    //                     sshUserPrivateKey(
    //                         credentialsId: 'ansible-server-key',
    //                         keyFileVariable: 'ANSIBLE_KEY'
    //                     )
    //                 ]) {
    //                     remote.identityFile = ANSIBLE_KEY
    //                     sshCommand remote: remote, command: """
    //                         cd /home/${ANSIBLE_USER} &&
    //                         chmod 600 ssh-key.pem &&
    //                         ansible-playbook -i inventory_aws_ec2.yaml my-playbook.yaml -vv
    //                     """
    //                 }
    //             }
    //         }
    //     }

    // } // end stages
} // end pipeline
