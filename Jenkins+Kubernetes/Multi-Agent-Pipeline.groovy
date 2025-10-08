pipeline {
    agent none
    /* agent {
        kubernetes{
            // label 'go-pod-label'
            inheritFrom 'go-pod-name'
            //defaultContainer 'go-container-name'
        }
    }
    */
    stages {
        stage('GoLang') {
            agent {
                kubernetes{
                    inheritFrom 'go-pod-name'
                }
            }
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
        stage('Maven') {
            agent {
                kubernetes{
                    inheritFrom 'maven-pod-name'
                }
            }
            steps {
               container ('maven-container-name'){
                    echo 'Hello World'
                    sh """
                    whoami
                    hostname
                    mvn -version
                    """
               }
            }
        } // End of stage Maven
        stage('Python') {
            agent {
                kubernetes{
                    inheritFrom 'python-pod-name'
                }
            }
            steps {
               container ('python-container-name'){
                    echo 'Hello World'
                    sh """
                    whoami
                    hostname
                    python3 --version
                    """
               }
            }
        } // End of stage python
        stage('Node') {
            agent {
                kubernetes{
                    inheritFrom 'node-pod-name'
                }
            }
            steps {
               container ('node-container-name'){
                    echo 'Hello World'
                    sh """
                    whoami
                    hostname
                    npm -v
                    node -v
                    """
               }
            }
        } // End of stage Node
    } // End of stages
} // End of pipeline 

