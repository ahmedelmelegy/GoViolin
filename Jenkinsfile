pipeline {
    agent any
    tools {
        go 'go-1.21.4'
        sonarScanner 'SonarScanner'
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
                withSonarQubeEnv('SonarScanner') {
                    sh 'sonar-scanner'
                }
            }
        }
    }
}
