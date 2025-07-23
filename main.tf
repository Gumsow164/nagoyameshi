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
  backend "s3" {
    bucket  = "nagoyameshi-tfstate-backet-0929"
    key     = "nagoyameshi-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
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
