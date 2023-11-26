pipeline {
    agent any
    tools {
        go 'go-1.21.4'
        sonarqube 'SonarScanner'
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
                withSonarQubeEnv('sonarQube instance') {
                    sh 'sonar-scanner'
                }
            }
        }
    }
}
