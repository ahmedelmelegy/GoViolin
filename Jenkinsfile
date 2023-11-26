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
        sh 'go mod init'
        sh 'go build -o goviolin .'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('SonarScanner') {
          sh 'sonar-scanner'
        }

      }
    }

    stage('sonar') {
      steps {
        withSonarQubeEnv(installationName: 'SonarScanner', credentialsId: 'SonarQube')
      }
    }

  }
  tools {
    go 'go-1.21.4'
  }
}