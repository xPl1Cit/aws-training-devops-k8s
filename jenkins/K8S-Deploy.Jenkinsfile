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
                    
                        chmod +x ./deploy-cluster.sh
                        ./deploy-cluster.sh ${params.REGION} ${params.ENV}
                    """
                }
            }
        }
        
        stage('Provision Helper Services') {
			steps {
				script {
					build job: 'Deploy Services',
						  parameters: [
							  string(name: 'REGION', value: "${REGION}"),
							  string(name: 'ENVIRONMENT', value: "${ENV}")
						  ],
						  wait: true
				}
				
				script {
					build job: 'Deploy Database',
						  parameters: [
							  string(name: 'REGION', value: "${REGION}"),
							  string(name: 'ENVIRONMENT', value: "${ENV}")
						  ],
						  wait: true
				}
			}
		}
		
		stage('Deploy Images') {
			steps {
				script {
					build job: 'Deploy Spring',
						  parameters: [
							  string(name: 'REGION', value: "${REGION}"),
							  string(name: 'VERSION', value: "latest"),
							  string(name: 'DEPLOYMENT_COLOR', value: "blue"),
							  string(name: 'ENVIRONMENT', value: "${ENV}")
						  ],
						  wait: true
				}
				
				script {
					build job: 'Deploy Angular',
						  parameters: [
							  string(name: 'REGION', value: "${REGION}"),
							  string(name: 'VERSION', value: "latest"),
							  string(name: 'DEPLOYMENT_COLOR', value: "blue"),
							  string(name: 'ENVIRONMENT', value: "${ENV}")
						  ],
						  wait: true
				}
			}
		}
		
		stage('Provision Metrics') {
			steps {
				script {
					build job: 'Deploy Metrics',
						  wait: true
				}
			}
		}
    }
}
