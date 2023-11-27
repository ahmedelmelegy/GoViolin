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

    stage('dependency-check') {
      steps {
        script {
          def dependencyCheck = 'dependency-check' // Name of the Dependency-Check tool installation in Jenkins
          sh "${tool name: dependencyCheck, type: 'org.jenkinsci.plugins.tools.ToolInstallation'} -f JSON -s ${WORKSPACE}/dependency-check-report -o ${WORKSPACE}/dependency-check-report.html -d ${WORKSPACE}/dependencies"
        }
      }
    }
  }

  }
  tools {
    go 'go-1.21.4'
  }
  environment {
    scannerTool = 'SonarScanner'
  }
}
