terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# The Map variable defining environment sizes
variable "environments" {
  type = map(string)
  default = {
    staging = "t3.micro"
    prod    = "t3.small"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# FOR_EACH RESOURCE LOOP
resource "aws_instance" "env_servers" {
  for_each      = var.environments  # Loops over the map keys
  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value        # Evaluates to t3.micro or t3.small

  tags = {
    Name = "Server-${each.key}"     # Evaluates to Server-staging or Server-prod
  }
}
