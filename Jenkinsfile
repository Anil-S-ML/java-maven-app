pipeline {
    agent any

    environment {
        ANSIBLE_SERVER = '20.17.177.229'
    }

    stages {
        stage("Copy files to ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to Ansible control node..."

                    sshagent(['ansible-server-key']) {
                        sh """
                                scp -o StrictHostKeyChecking=no ansible/* ansible@${ANSIBLE_SERVER}:/home/ansible/
                            """
                    }

                    withCredentials([
                        sshUserPrivateKey(
                            credentialsId: 'ec2-server-key',
                            keyFileVariable: 'KEYFILE',
                            usernameVariable: 'user'
                        )
                    ]) {
                      sh "scp -o StrictHostKeyChecking=no ${keyfile} ansible@${ANSIBLE_SERVER}:/home/ansible/ssh-key.pem"
                    }
                }
            }
        }

        // Uncomment this stage if you want to execute the playbook
        // stage("Execute Ansible playbook") {
        //     steps {
        //         script {
        //             echo "Calling ansible playbook to configure EC2 instances..."
        //
        //             def remote = [:]
        //             remote.name = "ansible-server"
        //             remote.host = "${ANSIBLE_SERVER}"
        //             remote.user = "ansible"
        //             remote.allowAnyHosts = true
        //
        //             withCredentials([
        //                 sshUserPrivateKey(
        //                     credentialsId: 'ansible-server-key',
        //                     keyFileVariable: 'ANSIBLE_KEY'
        //                 )
        //             ]) {
        //                 remote.identityFile = ANSIBLE_KEY
        //                 sshCommand remote: remote, command: """
        //                     cd /home/ansible &&
        //                     ansible-playbook -i inventory_aws_ec2.yaml my-playbook.yaml -vv
        //                 """
        //             }
        //         }
        //     }
        // }

    } // end stages
} // end pipeline
