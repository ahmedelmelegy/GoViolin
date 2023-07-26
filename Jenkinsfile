pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                echo "$GIT_BRANCH"
                sh 'docker images -a'
            }
        }


    stage('test') {
        steps {
            sh 'mvn test'
        }
        post {
            always {
            junit(
                allowEmptyResults: true,
                testResults: 'target/surefire-reports/*.xml'
                )
            }
        }
    }

    stage('build package') {
        steps {
            sh 'mvn clean package'
        }
    }
    stage('build image') {
        steps {
            sh("""
                docker build -t ahmedelmelegy3570/iti-g111 .
                docker images -a
                docker push ahmedelmelegy3570/iti-g111
            """)
            }
        }
    }
}