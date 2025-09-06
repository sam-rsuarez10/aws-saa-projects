terraform {
  required_version = ">= 1.13.1"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "remote-backends-e3906c698631"
    key = "iam-role-factory/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}