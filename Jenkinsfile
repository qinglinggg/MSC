pipeline {
    agent any
    
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        
        stage('Compile') {
            
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
        
        stage('Build') {
            
            steps {
                sh "docker build . --file=Dockerfile.frontend -t jsuryadharma/msc_frontend:version-${currentBuild.number}"
                sh "docker build . --file=Dockerfile.backend -t jsuryadharma/msc:version-${currentBuild.number}"
                
                script{      
                    try{
                        sh "docker rmi jsuryadharma/msc_frontend:latest"
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
            }
            
        }
        
        stage('Upload to Registry'){
        
            steps {              
                // docker push
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]){
                    sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                    script{
                        try{
                            sh "docker image pull ${USERNAME}/msc_frontend:latest"
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
                    script{
                        try{
                            sh "docker tag ${USERNAME}/msc_frontend:latest ${USERNAME}/msc_frontend:version-${currentBuild.previousBuild.getNumber()}"
                            sh "docker tag ${USERNAME}/msc:latest ${USERNAME}/msc:version-${currentBuild.previousBuild.getNumber()}"
                        } catch(error){
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                            echo 'Image tagging from previous version failed!'
                            echo 'continuing...'
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                        }
                    }

                    sh "docker tag ${USERNAME}/msc_frontend:version-${currentBuild.number} ${USERNAME}/msc_frontend:latest"
                    sh "docker tag ${USERNAME}/msc:version-${currentBuild.number} ${USERNAME}/msc:latest"
                    
                    // docker hub push
                    sh "docker push ${USERNAME}/msc_frontend:latest"
                    sh "docker push ${USERNAME}/msc:latest"
                    
                    sh "docker push ${USERNAME}/msc_frontend:version-${currentBuild.number}"
                    sh "docker push ${USERNAME}/msc:version-${currentBuild.number}"
                    
                    
//                  sh "chmod +x changeTag.sh"
//                  sh "./changeTag.sh version-${currentBuild.number}"
                }
            }
        
        }
             
        stage('Deploy') {
            
            steps {
                script{
                    try{
                        // Convert docker compose for Kubernetes config files
                        sh "kompose convert -f docker-compose.yml -f docker-compose-frontend.yml"
                        // Creating pods and services for Kubernetes, if there are changes then apply it.
                        sh "kubectl apply -f frontend-service-deployment.yaml"
                        sh "kubectl apply -f frontend-service-service.yaml"
                        sh "kubectl apply -f backend-service-deployment.yaml"
                        sh "kubectl apply -f backend-service-service.yaml"
                    } catch(error) {
                        sh "kubectl create -f frontend-service-deployment.yaml"
                        sh "kubectl create -f frontend-service-service.yaml"
                        sh "kubectl create -f backend-service-deployment.yaml"
                        sh "kubectl create -f backend-service-service.yaml"
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
