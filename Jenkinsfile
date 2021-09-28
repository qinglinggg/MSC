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
                sh "mvn clean compile"
            }
        }
        
        stage('Test') { 
            steps {
                sh 'mvn test'
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
                sh 'mvn package'
            }
            post {
                success {
                    // So that, Jenkins (CICD Platform) can recognize that there is a new artifacts to be archived.
                    archiveArtifacts 'target/*.jar'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                // build docker image
                sh "docker build . -t jsuryadharma/msc:${DOCKER_TAG}"
                
                // docker push
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]){
                    sh "docker login -u jsuryadharma -p ${dockerHubPwd}"
                    sh "docker push jsuryadharma:${DOCKER_TAG}"
                }
                
                // deploy to kubernetes k8s
                steps {
                    sh "chmod +x changeTag.sh"
                    sh "./changeTag.sh ${DOCKER_TAG}"
                }
            }
        }
        
        stage('Deliver') {
            steps {
                // Deliver the codes using docker to run a virtual environment of the Application.
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}
