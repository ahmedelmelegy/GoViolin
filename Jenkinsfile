pipeline {
    agent any
    tools {
        go 'go-1.21.4'
        sonarqube 'SonarScanner' // Ensure 'SonarScanner' matches the tool name in Jenkins
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
                withSonarQubeEnv('sonar-scanner') {
                    // Run the SonarScanner directly within the withSonarQubeEnv block
                    sh 'sonar-scanner'
                }
            }
        }
    }
}
