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
        tool(name: 'dependency-check', type: 'dependency-check')
        dependencyCheck(odcInstallation: 'dependency-check', additionalArguments: '--format HTML 	--nvdDatafeed https://services.nvd.nist.gov/rest/json/cves/2.0?cpeName=cpe:2.3:o:microsoft:windows_10:1607:*:*:*:*:*:*:* --nvdApiDelay 8000', skipOnUpstreamChange: true)
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
