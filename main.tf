#---------------------------------
# Terraform configuration
#---------------------------------
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
#---------------------------------
# Provider
#---------------------------------
provider "aws" {
  region  = "ap-northeast-1"
  profile = "terraform"
}

#---------------------------------
# Variables
#---------------------------------
variable "project" {
  type = string
}
variable "enviroment" {
  type = string
}
