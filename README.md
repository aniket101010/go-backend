# Project: go-backend
## Project workflow
- Step 1 > Launch ec2 instances
-  Step 2 > Install Package 
````
sudo apt update
````
## Install Docker
````
sudo apt install -y docker.io docker-compose
   sudo systemctl enable docker
   sudo systemctl start docker
   sudo usermod -aG docker $USER
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
## Create Directory backend
````
mkdir backend
````
````
cd backend
````
### Create main.go file and copy the code from main.go file in backend directory
````
sudo vim main.go
````

## create Dockerfile 
````
sudo vi dockerfile
````
## Copy Code for Dockerfile from backend directory
````
docker build -t backend .
````
## go back
````
cd ..
````
## create Frontend directory
```
