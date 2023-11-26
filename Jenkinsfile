pipeline {
  agent any
  tools {
    go 'go-1.21.4'
  }
  environment {
      scannerTool = 'sonar-scanner' // Define the SonarScanner tool separately
  }
  stages {
    stage('Checkout') {
      steps {
        echo "$GIT_BRANCH"
        sh 'docker images -a'
      }
    }

    stage('build app') {
      steps {
        sh 'go mod init'
        sh 'go build -o goviolin .'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        def scannerHome = tool 'sonar-scanner';
        withSonarQubeEnv(installationName: 'sonarQube instance', credentialsId: 'SonarQube') {
          sh "${scannerHome}/bin/sonar-scanner"
        }

      }
    }


  }
}
