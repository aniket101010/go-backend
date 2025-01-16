# Project: go-backend
## Project workflow
## Step 1 > Launch ec2 instances
### Prequisites for instance
instance type - t2.medium
ami - Ubuntu
Volume- 25gb SSD
Security port inbound
1) 80  
2) 8080 
3) 82
4) 81
## Step 2 > Install Package 
````
sudo -i
````
````
apt update
````
### Install Docker
````
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
````
### Docker-Compose

````
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
````
### Install Terraform
````
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform

````
### Jenkins Install
````
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt update
sudo apt install jenkins -y
````
### Java install for jenkins
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
### Install go package
````
sudo apt install -y golang-go
````
### Install Trivy
````
TRIVY_VERSION="0.43.1"
wget https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
tar -zxvf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
sudo mv trivy /usr/local/bin/
````
## Step 3
### Clone this repository in terminal for further steps
````
git clone https://github.com/aniket101010/go-backend.git
````
````
cd go-backend/
````
````
ls
````
### Go to terraform directory and use following commands, as other directories have images for Frontend and Backend Dockerfile for images and docker-compose.yml file.

````
terraform init
````
````
terraform plan
````
````
terraform validate
````
## Step 4
### After that hit IP-address:8080 and login as admin user in jenkins and add given plugins given below.
![Screenshot 2025-01-14 142426](https://github.com/user-attachments/assets/2f9139ac-ff81-486f-a0fe-2f5112a715a4)

- dockercompose plugin
- docker plugin
- docker pipline plugin
- pipline: stage view
- webhook trriger plugin

### Use this script in pipeline and then save apply and build now

````
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository from GitHub
                git branch: 'main', credentialsId: 'aniket', url: 'https://github.com/aniket101010/go-backend.git'
            }
        }
        stage('Build Backend') {
            steps {
                // Build the backend Docker image
                sh 'docker build -t go-backend ./Backend'
            }
        }
        stage('Scan Backend Image with Trivy') {
            steps {
                // Scan the backend Docker image for vulnerabilities
                sh '''
                trivy image --exit-code 1 --severity HIGH go-backend || echo "Trivy scan failed for Backend"
                '''
            }
        }
        stage('Build Frontend') {
            steps {
                // Build the frontend Docker image
                sh 'docker build -t static-frontend ./Frontend'
            }
        }
        stage('Scan Frontend Image with Trivy') {
            steps {
                // Scan the frontend Docker image for vulnerabilities
                sh '''
                trivy image --exit-code 1 --severity HIGH static-frontend || echo "Trivy scan failed for Frontend"
                '''
            }
        }
        stage('Deploy Containers') {
            steps {
                // Deploy the containers using docker-compose
                sh 'docker-compose up -d'
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution complete.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for errors.'
        }
    }
}
````
## Step 5 (Optional)
### Log in to the AWS Management Console:

Navigate to the EC2 dashboard  Load Balancers section.
### Choose a Load Balancer Type
- Application Load Balancer (ALB): Best for HTTP/HTTPS traffic
- Configure Load BaName: Provide a meaningful name.lancer Settings
- Name: Provide a meaningful name
- Scheme: Choose Internet-facing (public) or Internal (private)
- IP Address Type: IPv4 or Dualstack (for IPv6 support)
- Listeners: Add protocol and port (e.g., HTTP:80, HTTPS:443).
### Select Target VPC and Subnets:
- Choose a VPC where the load balancer will operate
- Select at least two subnets for high availability (different Availability Zones)
### Configure Security Groups
- Attach or create a security group for the load balancer
- Allow necessary traffic (e.g., HTTP, HTTPS)
  ![Screenshot 2025-01-15 170401](https://github.com/user-attachments/assets/bd385e8e-076c-46b2-9f42-3a0d06271b00)
  
![Screenshot 2025-01-15 171642](https://github.com/user-attachments/assets/ba87ea0c-7214-4ab1-b1ce-a8a5a4ce79c1)

### Create a Target Group
- Choose target type: Instances, IP addresses, or Lambda functions
- Configure the health check protocol, path, and thresholds
-  Add Targets: Register the EC2 instances or other resources
  ![Screenshot 2025-01-15 171340](https://github.com/user-attachments/assets/7cb152ca-5d1d-4776-b701-875cead9a7be)

### Review and Create
- Review the configuration summary
- Click Create to provision the load balancer



