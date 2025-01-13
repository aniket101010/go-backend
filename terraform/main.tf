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

resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_container" "backend" {
  name  = "go-backend"
  image = "go-backend-image"
  ports {
    internal = 8080
    external = 8081
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "frontend" {
  name  = "static-frontend"
  image = "frontend-image"
  ports {
    internal = 80
    external = 8082
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "reverse_proxy" {
  name  = "nginx-reverse-proxy"
  image = "nginx:alpine"
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
}
