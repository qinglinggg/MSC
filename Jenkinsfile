pipeline {
    agent any
    
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        
        stage('Maven - Compile') {
            
            steps {
                git branch: 'main', url: 'https://github.com/qinglinggg/MSC.git'
                // clean the target forder, so only the newer components + artifacts will be released.
                sh "mvn clean compile"
            }
            
        }
        
        stage('Maven - Test') { 
            
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
        
        stage('Maven - Package') {
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
        
        stage('Docker - Image Build') {
            
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
        
        stage('Docker - Upload to Registry'){
        
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
             
        stage('Docker - Deployment') {
            
            steps {
                script{
                    try{
                        sh "docker-compose -f docker-compose.yml up -d"
                    } catch(error) {
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                            echo 'Deploying to docker compose failed!'
                            echo 'continuing...'
                            echo '+++++++++++++++++++++++++++++++++++++++++++++++++++'
                    }
                }
            }
            
        }
        
        stage('Summary - Check Builds') {
            
            steps {
                echo "current build number: ${currentBuild.number}"
                echo "previous build number: ${currentBuild.previousBuild.getNumber()}"
            }
            
        }
        
    }
    
}
