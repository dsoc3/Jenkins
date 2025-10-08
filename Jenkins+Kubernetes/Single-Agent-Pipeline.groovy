pipeline {
    agent {
        kubernetes{
            // label 'go-pod-label'
            inheritFrom 'go-pod-name'
            //defaultContainer 'go-container-name'
        }
    }
    stages {
        stage('GoLang') {
            steps {
               container ('go-container-name'){
                    echo 'Hello World'
                    sh """
                    whoami
                    hostname
                    go version
                    """
               }
            }
        } // End of stage GoLang
    } // End of stages
} // End of pipeline 
