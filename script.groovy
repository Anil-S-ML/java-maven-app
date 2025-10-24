// def buildJar() {
//     echo 'Building the application ...'
//     sh 'mvn package'
// }

// def buildImage() {
//     echo "Building the Docker image ..."

//     withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
//         sh 'docker build -t anil2469/applisting:jma-2.0 .'
//         sh 'echo $PASS | docker login -u $US --password-stdin'
//         sh 'docker push anil2469/applisting:jma-2.0'
//     }
// }

// def deployApp() {
//     echo 'Deploying the application ...'
//     // Add your deployment steps here
// }

// return this
