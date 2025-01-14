# Project: go-backend
## Project workflow
- Step 1 > Launch ec2 instances
-  Step 2 > Install Package 
````
sudo apt update
````
## Install Docker
````
sudo apt install -y docker.io 
   sudo systemctl enable docker
   sudo systemctl start docker
   sudo usermod -aG docker jenkins
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
````
sudo terraform apply -auto-approve
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
        stage('Build Frontend') {
            steps {
                sh 'docker build -t static-frontend ./Frontend'
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
