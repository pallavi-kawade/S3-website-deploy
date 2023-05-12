pipeline {
    agent any
    tools {
        tool name: 'Terraform', type: 'terraform'
    }
    

    stages {
        stage('checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/pallavi-kawade/S3-website-deploy.git']])
            }
        }
    }
    
        stage('init') {
            steps {
                sh ('terraform init')
            }
        }
        
        stage('plan') {
            steps {
                sh ('terraform plan')
            }
        }
        
        stage('apply') {
            steps {
                sh ('terraform apply')
            }
        }
    }

