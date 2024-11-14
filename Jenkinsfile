pipeline {
    agent any
    environment {
        HELM_HOME = tool 'helm'
        AWS_CLI = tool 'aws-cli'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'GITHUB', url: 'https://github.com/your-repo-url.git'
            }
        }
        stage('Set up Helm') {
            steps {
                withEnv(["PATH+HELM=${HELM_HOME}/bin"]) {
                    sh 'helm version'
                }
            }
        }
        stage('Set up AWS CLI') {
            steps {
                withEnv(["PATH+AWS=${AWS_CLI}/bin"]) {
                    sh 'aws --version'
                }
            }
        }
        }
        stage('Deploy API with Helm') {
            steps {
                script {
                    def API_IMAGE_TAG = "api-${env.BUILD_ID}"
                    withEnv(["PATH+HELM=${HELM_HOME}/bin", "PATH+AWS=${AWS_CLI}/bin"]) {
                        sh """
                          aws eks update-kubeconfig --name my-cluster --region us-east-1
                          helm upgrade --install api ./k8s --set api.image=your-docker-hub-username/backend --set api.tag=${API_IMAGE_TAG} --namespace default
                        """
                    }
                }
            }
        }
        stage('Deploy Frontend with Helm') {
            steps {
                script {
                    def FRONTEND_IMAGE_TAG = "frontend-${env.BUILD_ID}"
                    withEnv(["PATH+HELM=${HELM_HOME}/bin", "PATH+AWS=${AWS_CLI}/bin"]) {
                        sh """
                          aws eks update-kubeconfig --name my-cluster --region us-east-1
                          helm upgrade --install frontend ./k8s --set frontend.image=your-docker-hub-username/frontend --set frontend.tag=${FRONTEND_IMAGE_TAG} --namespace default
                        """
                    }
                }
            }
        }
    }
}
