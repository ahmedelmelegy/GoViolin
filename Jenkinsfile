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
          def dependencyCheck = tool name: 'dependency-check', type: 'org.jenkinsci.plugins.tools.ToolInstallation'

          if (dependencyCheck) {
            sh "${dependencyCheck}/bin/dependency-check.sh -f JSON -s ${WORKSPACE}/dependency-check-report -o ${WORKSPACE}/dependency-check-report.html -d ${WORKSPACE}/dependencies"
          } else {
            error "Dependency-Check tool not found. Please check tool configuration in Jenkins."
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
