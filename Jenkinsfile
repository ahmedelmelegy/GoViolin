pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        echo "$GIT_BRANCH"
        sh 'docker images -a'
      }
    }

    stage('build app') {
      steps {
        sh 'go build -o goviolin .'
      }
    }
    stage('SonarQube Analysis') {
        steps {
            node {
                // Checkout the code from source control
                checkout scm

                // Run SonarQube analysis
                def scannerHome = tool 'SonarScanner'
                withSonarQubeEnv {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
  }
}
