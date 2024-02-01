pipeline {
    agent any
    
    environment {
    GITWEBADD = 'https://github.com/hwanginkyung/image-test.git'
    GITSSHADD = 'git@github.com:hwanginkyung/image-test.git'
    GITCREDENTIAL = 'git_cre'
    
    ECR_REPO_URL = '109412806537.dkr.ecr.us-east-1.amazonaws.com/hik-test'
    ECR_CREDENTIAL = 'aws_cre'
}

        
    stages {
        stage('Checkout Github') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [],
                userRemoteConfigs: [[credentialsId: GITCREDENTIAL, url: GITWEBADD]]])
            }

            post {
                failure {
                    echo '리포지토리 복제 실패'
                }
                success {
                    echo '리포지토리 복제 성공'
                }
            }
        }
        stage('image build') {
            steps {
                sh "docker build -t ${ECR_REPO_URL}:${currentBuild.number} ."
                sh "docker build -t ${ECR_REPO_URL}:latest ."
            }
        }
        stage('image push') {
            steps {
                // AWS ECR에 로그인
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: ECR_CREDENTIAL]]) {
                    script {
                        def ecrLogin = sh(script: "aws ecr get-login-password --region us-east-1", returnStdout: true).trim()
                        sh "docker login -u AWS -p ${ecrLogin} ${ECR_REPO_URL}"
                    }
                }

                // 이미지를 AWS ECR로 푸시
                sh "docker push ${ECR_REPO_URL}:${currentBuild.number}"
                sh "docker push ${ECR_REPO_URL}:latest"
            }
            
            post {
                failure {
                    echo 'AWS ECR로 이미지 푸시 실패'
                    sh "docker image rm -f ${ECR_REPO_URL}:${currentBuild.number}"
                    sh "docker image rm -f ${ECR_REPO_URL}:latest"
                }
                
                success {
                    echo 'AWS ECR로 이미지 푸시 성공'
                    sh "docker image rm -f ${ECR_REPO_URL}:${currentBuild.number}"
                    sh "docker image rm -f ${ECR_REPO_URL}:latest"
                }
            }
        }
    }
}
