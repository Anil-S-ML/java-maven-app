def buildApp(version) {
    echo "Building the application version: ${version}"
}

def testApp() {
    echo "Testing the application ..."
}

def deployApp(version) {
    echo "Deploying the application ..."
    echo "Deploying version ${version}"
}

return this
