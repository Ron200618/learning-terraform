# Fetch the provider configuration from Lab 1
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

# DATA SOURCE: Look up your default AWS network
data "aws_vpc" "default_network" {
  default = true
}

# RESOURCE: Use the data source's output ID to display it
output "my_default_vpc_id" {
  value = data.aws_vpc.default_network.id
}
