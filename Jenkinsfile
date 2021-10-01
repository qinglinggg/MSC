pipeline {
    agent any
//     agent {
//         docker {
//             image 'maven:3.8.1-adoptopenjdk-11' 
//             args '-v /root/.m2:/root/.m2' 
//         }
//     }
    environment {
        DOCKER_TAG = getDockerTag()
    }
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        stage('Build') {
            steps {
                git branch: 'main', url: 'https://github.com/qinglinggg/MSC.git'
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
//                 withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]){
//                     sh "docker login -u ${USERNAME} -p ${PASSWORD}"
//                     sh "docker push ${USERNAME}/msc:${DOCKER_TAG}"
//                 }
                    sh "chmod +x changeTag.sh"
                    sh "./changeTag.sh ${DOCKER_TAG}"
                script{
                    try{
                        // TODO: this
                        sh "kubectl apply -f ."
                        } catch(error) {
                        // TODO: this
                        sh "kubectl create -f ."
                    }
                }
//                     sshagent(['k8s-test']){
                        // TODO" this
//                         sh "scp -i StrictHostKeyChecking=no services.yml aws-image-upload-pods.yml k8s-docker-demo-for-josur@34.133.165.254"
//                     }
            }
        }
        
        stage('Deliver') {
            steps {
                // Deliver the codes using docker to run a virtual environment of the Application.
//                 sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
