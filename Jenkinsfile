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
        script {
          def scannerHome = tool 'SonarScanner';
          withSonarQubeEnv(installationName: 'sonarQube instance', credentialsId: 'SonarQube') {
            sh "${scannerHome}/bin/sonar-scanner"
          }
        }

      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 1, unit: 'HOURS') {
          waitForQualityGate(abortPipeline: true)
        }

      }
    }
	stage('Vulnerability Scan - Docker') {
      steps {
      "Trivy Scan":{
        sh "bash trivy-docker-image-scan.sh"
      }
      }
    }
    stage('build image') {
      steps {
        sh 'docker build . -t goviolin-multistage'
      }
    // stage('dependency-check') {
    //   steps {
    //     sh "go dependency-check:check"
    //   }
    }
    

  }
  tools {
    go 'go-1.16.15'
  }
  environment {
    scannerTool = 'SonarScanner'
    imageName = "ahmedelmelegy3570/goviolin-multistage:${GIT_COMMIT}"
  }
}
