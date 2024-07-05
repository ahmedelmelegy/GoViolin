@Library("shared-library") _
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
        // sh 'go mod init'
        sh 'go build -o goviolin .'
      }
    }

    // stage('SonarQube Analysis') {
    //   steps {
    //     script {
    //       def scannerHome = tool 'SonarScanner';
    //        withSonarQubeEnv() {
    //         sh "${scannerHome}/bin/sonar-scanner"
    //       }
    //     }

    //   }
    // }

    // stage('Quality Gate') {
    //   steps {
    //     timeout(time: 1, unit: 'HOURS') {
    //       script {
    //         def qg = waitForQualityGate()
    //         echo "Quality Gate status: ${qg.status}"
    //         if (qg.status != 'OK') {
    //           error "Pipeline aborted due to quality gate failure: ${qg.status}"
    //         }
    //       }
    //     }

    //   }
    // }
  stage('build image') {
    steps {
      // sh 'docker build . -t ""$imageName""'
       buildPushtoHub([DockerCredentials: "DOCKERHUB",image: "${imageName}:${BUILD_NUMBER}",context:"."])
    }
  }
	stage('Vulnerability Scan - Docker Trivy') {
      steps {
        sh "bash trivy-docker-image-scan.sh "
        archiveArtifacts artifacts: 'trivy_scan_results.txt', followSymlinks: false
      }
    }
    // stage('dependency-check') {
    //   steps {
    //     sh "go dependency-check:check"
    //   }
    

  }
  tools {
    go 'go-1.16.15'
  }
  environment {
    // scannerTool = 'SonarScanner'
    imageName = "ahmedelmelegy3570/goviolin-multistage"
  }
}
