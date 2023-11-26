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