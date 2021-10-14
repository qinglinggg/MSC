pipeline {
    agent any
    
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
                sh "docker build --file=Dockerfile.dev -t jsuryadharma/msc_dev:version-${currentBuild.number}"
                sh "docker build --file=Dockerfile.prod -t jsuryadharma/msc_prod:version-${currentBuild.number}"
                sh "docker build --file=Dockerfile.backend -t jsuryadharma/msc:version-${currentBuild.number}"
                script{
                    try{
                        sh "docker rmi jsuryadharma/msc_dev:latest"
                        sh "docker rmi jsuryadharma/msc_prod:latest"
                        sh "docker rmi jsuryadharma/msc:latest"
                        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                        echo 'docker for latest version of image is available..'
                        echo 'removed latest local version of image!'
                        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                    }catch(error){
                        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                        echo 'docker for latest version of image is unavailable..'
                        echo 'ignoring...'
                        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                    }
                }
                // docker push
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]){
                    sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                    script{
                        try{
                            sh "docker image pull ${USERNAME}/msc_dev:latest"
                            sh "docker image pull ${USERNAME}/msc_prod:latest"
                            sh "docker image pull ${USERNAME}/msc:latest"
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                            echo 'pulled image : latest version successfully!'
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                        }catch(error){
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                            echo 'pulling image : latest version failed!'
                            echo 'continuing...'
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                        }
                    }
                    // docker retagging previous and current build
                    sh "docker tag ${USERNAME}/msc_dev:latest ${USERNAME}/msc_dev:version-${currentBuild.previousBuild.getNumber()}"
                    sh "docker tag ${USERNAME}/msc_prod:latest ${USERNAME}/msc_prod:version-${currentBuild.previousBuild.getNumber()}"
                    sh "docker tag ${USERNAME}/msc:latest ${USERNAME}/msc_backend:version-${currentBuild.previousBuild.getNumber()}"
                    
                    sh "docker tag ${USERNAME}/msc_dev:version-${currentBuild.number} ${USERNAME}/msc_dev:latest"
                    sh "docker tag ${USERNAME}/msc_prod:version-${currentBuild.number} ${USERNAME}/msc_prod:latest"
                    sh "docker tag ${USERNAME}/msc:version-${currentBuild.number} ${USERNAME}/msc_backend:latest"
                    
                    // docker hub push
                    sh "docker push ${USERNAME}/msc_dev:latest"
                    sh "docker push ${USERNAME}/msc_prod:latest"
                    sh "docker push ${USERNAME}/msc:latest"
                    
                    sh "docker push ${USERNAME}/msc_dev:version-${currentBuild.number}"
                    sh "docker push ${USERNAME}/msc_prod:version-${currentBuild.number}"
                    sh "docker push ${USERNAME}/msc:version-${currentBuild.number}"
                }
                
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh version-${currentBuild.number}"
                
                script{
                    try{
                        // Creating pods and services for Kubernetes, if there are changes then apply it.
                        sh "kubectl apply -f ."
                        } catch(error) {
                        sh "kubectl create -f ."
                    }
                }
            }
        }
        
        stage('Check Builds') {
            steps {
                echo "current build number: ${currentBuild.number}"
                echo "previous build number: ${currentBuild.previousBuild.getNumber()}"
            }
        }
    }
}
