Welcome to the Kubernetes (K8S) repository. This repository contains all the neccessary files to setup your Jenkins instance.

Please follow the following instructions:

1. Setup:
- When first opening the Jenkins UI, you will be asked to create an Admin account, please do so and note your user information in a Password manager
2. Credentials:
- Make sure to insert both your GitHub account and AWS CLI access token inside Jenkins
- In Jenkins please follow "Dashboard" -> "Manage Jenkins" -> "Credentials" -> "Global" -> "Add Credentials"
- We will need two entries of the "Username with password" kind:

- Scope: Global
- Username: {Your AWS access key ID}
- Password: {Your AWS access secret}
- Treat username as secret: recommended yes
- ID: aws-credentials

- Scope: Global
- Username: xPliC1t
- Password: {Will be provided by Andreas}
- Treat username as secret: recommended yes
- ID: github-token

3. Pipelines:
- We will need to setup a total of 9 pipelines to complete your Jenkins setup. Please create a new Item for each and follow the instructions on how to create each

Pipeline 1
- Name: Build Angular
- Type: Multibranch Pipeline
- Display Name: Build Angular
- Description (optional): This pipeline is used to build the Frontend Angular application
- Branch Sources:
  - Credentials: Use the Github-token
  - Repository-URL: https://github.com/xPl1Cit/aws-training-devops-angular.git
  - Add "File by name (with wildcards)": "test prod"
-  Build Configuration:
  - Mode: By Jenkinsfile
  - Path: "Jenkinsfile"
- Orphaned Item Strategy
  - Discard old items: true
    - max# of items to keep: 10


Pipeline 2
- Name: Build Spring
- Type: Multibranch Pipeline
- Display Name: Build Spring
- Description (optional): This pipeline is used to build the SpringBoot application backend
- Branch Sources:
  - Credentials: Use the Github-token
  - Repository-URL: https://github.com/xPl1Cit/aws-training-devops-spring.git
  - Add "File by name (with wildcards)": "test prod"
- Build Configuration:
  - Mode: By Jenkinsfile
  - Path: "Jenkinsfile"
- Orphaned Item Strategy
  - Discard old items: true
    - max# of items to keep: 10


Pipeline 3
- Name: Deploy Angular
- Type: Pipeline
- Display Name: Deploy Angular
- Description (optional): This pipeline is used to deploy the Frontend Angular application
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/Angular.Jenkinsfile"


Pipeline 4
- Name: Deploy Database
- Type: Pipeline
- Display Name: Deploy Database
- Description (optional): This pipeline is used to deploy the PostgreSQL database for the application
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/Database.Jenkinsfile"


Pipeline 5
- Name: Deploy Metrics
- Type: Pipeline
- Display Name: Deploy Metrics
- Description (optional): This pipeline is used to deploy the metrics in form of Grafana and Prometheus
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/Metrics.Jenkinsfile"


Pipeline 6
- Name: Deploy Services
- Type: Pipeline
- Display Name: Deploy Services
- Description (optional): This pipeline is used to deploy the necessary services for the pods to connect and be exposed
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/Services.Jenkinsfile"


Pipeline 7
- Name: Deploy Spring
- Type: Pipeline
- Display Name: Deploy Spring
- Description (optional): This pipeline is used to deploy the SpringBoot application backend
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/Spring.Jenkinsfile"


Pipeline 8
- Name: Deploy K8S
- Type: Pipeline
- Display Name: Deploy K8S
- Description (optional): This pipeline is used to deploy the Kubernetes Cluster and deploy the application to be ready to use
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/K8S-Deploy.Jenkinsfile"


Pipeline 8
- Name: Teardown K8S
- Type: Pipeline
- Display Name: Teardown K8S
- Description (optional): This pipeline is used to teardown the Kubernetes cluster used for the application
- GitHub project URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
- This project is parameterized: true (will be populated on first retrieval of Jenkinsfile)
- Pipeline:
  - Definition: Pipeline script from SCM
  - SCM: Git
    - Repositories:
      - Repository URL: https://github.com/xPl1Cit/aws-training-devops-k8s/
      - Credentials: Use the Github-token
    - Branches to build: "main"
  - Script path: "jenkins/K8S-Teardown.Jenkinsfile"


Make sure that the names and Display names all match as they are crossreferences between pipelines.

When you have setup all the pipelines, be sure to run them all once to retrieve the parameters from the scripts.
CAUTION: This will fail the script for the first run.

4. Build Nodes
- Make sure to extend the concurrent possible build from 2 to something like 5 to allow multiple environments to be created and torn down at the same time
- Go to "Dashboard" -> "Build Executor Status" -> Click on Settiings wheel for "Built-In Node" -> Number of executor: 5

5. Build Kubernetes cluster
- Before building the Kubernetes cluster, be sure to run the Build Angular and Build Spring pipeline at least once successfully for the region and environment (test and prod) you want to deploy.
- When you successfully build the images and stored them into ECR, do not be confused, the deployment Pipelines for Angular and Spring will run and fail. This is not of any concern however.
- When the images are available you can utilize the Deploy K8S pipeline to deploy the Kubernetes cluster, services, database, Angular, SpringBoot and Grafana. This will take a considerable amount of time. So please be patient.

6. Accessing the frontends
- To access the application open the AWS console and navigate "Amazon Elastic Kubernetes Service" -> "Clusters" -> "{The cluster you deployed}" -> "Resources" -> "Service and networking" -> "Services"
- Here you will find a list of services that are running inside the Kubernetes cluster. There should be two Load Balancer services running "angular-lb" and "prometheus-grafana"
- Inside these Load Balancers you will find the URLs to access both the Angular frontend as well as the Grafana Dashboards to monitor the Kubernetes cluster.
- Be careful when clicking the links as they will most likely redirect you to https which is not available. Instead change it to http. Both application use Port 80, so you wont have to specify a specific port when using a standard browser.

7. Bonus: Monitoring SpringBoot Metrics
- When accessing the Grafana frontend it will have all Kubernetes related dashboards available by default.
- To add the SpringBoot Dashboard please navigate -> "Dashboards" -> "New" -> "Import" -> Find and import dashboards: "4701" -> "Load" -> Prometheus: Select the Prometheus instance -> "Import"
- Then you will have a Dashboard "JVM (Micrometer)" available to use.
- NOTE: It might take a couple of minutes to actually populate the relevant data. 
