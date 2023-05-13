pipeline {
    agent any
    tools {
        tool name: 'Terraform', type: 'terraform'
    }
    
    stages {
        stage('AWS demo') {
            steps {
                withCredentials([[
                    $class:"AmazonWebServicesCredentialsBinding",
                    credentialsID:"aws-jenkins-demo",
                    accessKeyVariable:"AWS_ACCESS_KEY_ID",
                    accessKeyVariable:"AWS_SECRET_ACCESS_KEY",
                        sh "aws s3 ls"

                ]])
            }
        }
    
     
        stage('checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/pallavi-kawade/S3-website-deploy.git']])
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

