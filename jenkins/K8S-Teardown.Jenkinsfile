pipeline {
    agent any

    parameters {
        string(name: 'REGION', defaultValue: 'us-east-1', description: 'AWS Region')
        string(name: 'ENV', defaultValue: 'test', description: 'Environment (e.g., test, prod)')
    }

    stages {
        stage('Pull GitHub Repo'){
            steps {
                git branch: 'main',
                    url: 'https://github.com/xPl1Cit/aws-training-devops-k8s',
                    credentialsId: 'github-token'
            }
        }
        
        stage('Provision EKS Cluster') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh """
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region ${params.REGION}
                        aws sts get-caller-identity
                    
                        chmod +x ./delete-cluster.sh
                        ./delete-cluster.sh ${params.REGION} ${params.ENV}
                    """
                }
            }
        }
    }
}
