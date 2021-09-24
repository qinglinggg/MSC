pipeline {
    agent any
//     agent {
//         docker {
//             image 'maven:3.8.1-adoptopenjdk-11' 
//             args '-v /root/.m2:/root/.m2' 
//         }
//     }
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {    
        stage('Build') {
            steps {
                git branch: 'main', url: 'https://github.com/qinglinggg/MySurveyCompanion.git'
                // clean the target forder, so only the newer components + artifacts will be released.
                bat "mvn clean compile"
            }
        }
        
        stage('Test') { 
            steps {
                bat 'mvn test'
            }
            post {
                always {
                    // Generates the Test Results, using the Maven for the Unit Testing, and show the results by JUnit.
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }
        
        stage('Package') {
            steps {
                bat 'mvn package'
            }
            post {
                success {
                    // So that, Jenkins (CICD Platform) can recognize that there is a new artifacts to be archived.
                    archiveArtifacts 'target/*.jar'
                }
            }
        }
        
        stage('Deliver') {
            steps {
                // Deliver the codes using docker to run a virtual environment of the Application.
                bat './jenkins/scripts/deliver.sh'
            }
        }
    }
}
