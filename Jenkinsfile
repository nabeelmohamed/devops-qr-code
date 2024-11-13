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
        stage('Deploy Backend') {
            steps {
                withEnv(["PATH+HELM=${HELM_HOME}/bin", "PATH+AWS=${AWS_CLI}/bin"]) {
                    sh '''
                      aws eks update-kubeconfig --name my-cluster --region us-east-1
                      helm upgrade --install backend ./helm/my-application \
                        --namespace default \
                        --values ./helm/values.yaml
                    '''
                }
            }
        }
        stage('Deploy Frontend') {
            steps {
                withEnv(["PATH+HELM=${HELM_HOME}/bin", "PATH+AWS=${AWS_CLI}/bin"]) {
                    sh '''
                      aws eks update-kubeconfig --name my-cluster --region us-east-1
                      helm upgrade --install frontend ./helm/my-application \
                        --namespace default \
                        --values ./helm/values.yaml
                    '''
                }
            }
        }
    }
}