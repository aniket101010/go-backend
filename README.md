# Project: go-backend
## Project workflow
- Step 1 > Launch ec2 instances
- security port inbound
- 80  
- 8080 
- 82
- 81
-  Step 2 > Install Package 
````
sudo apt update
````
## Install Docker
````
sudo apt install -y docker.io 
   sudo systemctl enable docker
   sudo systemctl start docker
   sudo usermod -aG docker $USER
newgrp docker
````
## Docker-Compose

````
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
````
 ## Install Terraform
````
  sudo apt install -y unzip
   wget https://releases.hashicorp.com/terraform/1.3.0/terraform_1.3.0_linux_amd64.zip
   unzip terraform_1.3.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   terraform -version
````
## Jenkins Install
````
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
````
## Java install for jenkins
````
sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version
openjdk version "17.0.13" 2024-10-15
OpenJDK Runtime Environment (build 17.0.13+11-Debian-2)
OpenJDK 64-Bit Server VM (build 17.0.13+11-Debian-2, mixed mode, sharing)
sudo systemctl start jenkns
sudo systemctl enable jenkins
sudo usermod -aG docker jenkins

````
## Install go package
````
sudo apt install -y golang-go
````

## Go to terraform directory and use following commands

````
sudo terraform init
````
````
sudo terraform plan
````
````
sudo terraform validate
````

## After that hit IP-address:8080 and login as admin user in jenkins and add given plugins given below.
![Screenshot 2025-01-14 142426](https://github.com/user-attachments/assets/2f9139ac-ff81-486f-a0fe-2f5112a715a4)

- dockercompose plugin
- docker plugin
- docker pipline plugin
- blue ocean plugin
- pipline plugin
- github plugin
- git plugin
- email extenison
- credentials plugin

## use this script in pipeline and then save apply and build now

````
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'aniket', url: 'https://github.com/aniket101010/go-backend.git'
            }
        }
        stage('Build Backend') {
            steps {
                sh 'docker build -t go-backend ./Backend'
            }
        }
        stage('Scan Backend Image with Trivy') {
            steps {
                sh '''
                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                aquasec/trivy image --exit-code 1 --severity HIGH go-backend
                '''
            }
        }
        stage('Build Frontend') {
            steps {
                sh 'docker build -t static-frontend ./Frontend'
            }
        }
        stage('Scan Frontend Image with Trivy') {
            steps {
                sh '''
                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                aquasec/trivy image --exit-code 1 --severity HIGH static-frontend
                '''
            }
        }
        stage('Deploy Containers') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}
````
##Log in to the AWS Management Console:

Navigate to the EC2 dashboard  Load Balancers section.
## Choose a Load Balancer Type
- Application Load Balancer (ALB): Best for HTTP/HTTPS traffic
- Configure Load BaName: Provide a meaningful name.lancer Settings
- Name: Provide a meaningful name
- Scheme: Choose Internet-facing (public) or Internal (private)
- IP Address Type: IPv4 or Dualstack (for IPv6 support)
- Listeners: Add protocol and port (e.g., HTTP:80, HTTPS:443).
## Select Target VPC and Subnets:
- Choose a VPC where the load balancer will operate
- Select at least two subnets for high availability (different Availability Zones)
## Configure Security Groups
- Attach or create a security group for the load balancer
- Allow necessary traffic (e.g., HTTP, HTTPS)
  ![Screenshot 2025-01-15 170401](https://github.com/user-attachments/assets/bd385e8e-076c-46b2-9f42-3a0d06271b00)
  
![Screenshot 2025-01-15 171642](https://github.com/user-attachments/assets/ba87ea0c-7214-4ab1-b1ce-a8a5a4ce79c1)

## Create a Target Group
- Choose target type: Instances, IP addresses, or Lambda functions
- Configure the health check protocol, path, and thresholds
-  Add Targets: Register the EC2 instances or other resources
  ![Screenshot 2025-01-15 171340](https://github.com/user-attachments/assets/7cb152ca-5d1d-4776-b701-875cead9a7be)

## Review and Create
- Review the configuration summary
- Click Create to provision the load balancer



