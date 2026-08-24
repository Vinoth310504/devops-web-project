terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-project-sg"
  description = "Security group for Jenkins and Docker"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.devops_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash

              set -e

              echo "======================================"
              echo "Starting DevOps Server Setup"
              echo "======================================"

              echo "Installing Docker..."

              ${file("${path.module}/scripts/docker.sh")}

              echo "Docker installation completed."

              echo "Installing Jenkins..."

              ${file("${path.module}/scripts/jenkins.sh")}

              echo "Jenkins installation completed."

              echo "Adding Jenkins user to Docker group..."

              usermod -aG docker jenkins

              systemctl restart docker
              systemctl restart jenkins

              echo "======================================"
              echo "DevOps Server Setup Completed"
              echo "======================================"
              EOF

  tags = {
    Name = "Terraform-DevOps-Server"
  }
}