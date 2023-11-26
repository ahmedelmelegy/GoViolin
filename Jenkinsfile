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
      post {
        always {
          junit(allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml')
        }

      }
      steps {
        sh '''go mod init
go build -o goviolin .'''
      }
    }

    stage('build image') {
      steps {
        sh '''
                docker build . -t goviolin-multistage
                docker images -a
                
            '''
      }
    }

  }
}