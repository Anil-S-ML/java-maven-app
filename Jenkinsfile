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

                    sshagent(['ansible-server-key']) {
                        sh """
                            scp -o StrictHostKeyChecking=no ansible/* ${ANSIBLE_USER}@${ANSIBLE_SERVER}:/home/${ANSIBLE_USER}/
                        """
                    }
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

        stage("Execute remote command (ls -l)") {
            steps {
                script {
                    echo "Listing files on the Ansible server..."

                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = "${ANSIBLE_SERVER}"
                    remote.user = "${ANSIBLE_USER}"
                    remote.allowAnyHosts = true

                    withCredentials([
                        sshUserPrivateKey(
                            credentialsId: 'ansible-server-key',
                            keyFileVariable: 'KEYFILE'
                        )
                    ]) {
                        remote.user = "${ANSIBLE_USER}"
                        remote.identityFile = KEYFILE
                        sshCommand remote: remote, command: "ansible-playbook my-playbook.yaml "
                    }
                }
            }
        }

    }
}
