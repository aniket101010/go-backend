# Project: go-backend
## aniket
### aniket
#### aniket
- step 1
- step 2
### Terraform Provider
````
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
````



##### update command
````
sudo apt update
````
