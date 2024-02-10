pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment{
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages{
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('git checkout'){
            steps{
                git 'https://github.com/mukeshr-29/project-30-cicd-jen-eks-trivypodscan.git'
            }
        }
        stage('install dependencies'){
            steps{
                sh 'npm install'
            }
        }
        stage('static code analusis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-token', installationName: 'sonar-server'){
                        sh '''
                            $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=reddis-31 \
                            -Dsonar.projectName=reddis-31 \
                        '''
                    }
                }
            }
        }
        stage('quality gate analysis'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('owasp dependency check'){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'dp-check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('trivy filescan'){
            steps{
                sh 'trivy fs . > trivyfs.txt'
            }
        }
        stage('docker build and tag'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){
                        sh 'docker build -t redditclone-1 .'
                        sh 'docker tag redditclone-1 mukeshr29/redditclone-1'
                    }
                }
            }
        }
        stage('trivy img scan'){
            steps{
                sh 'trivy image mukeshr29/redditclone-1 > trivyimg.txt'
            }
        }
        stage('push docker img to repo'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){
                        sh 'docker push mukeshr29/redditclone-1'
                    }
                }
            }
        }
        stage('deploy to eks fargate cluster'){
            steps{
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: ''){
                        sh 'kubectl apply -f deployment.yml -f service.yml -f ingress.yml'
                    }
                }
            }
        }
    }
}