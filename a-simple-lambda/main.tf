# Define the AWS provider with region and profile configurations
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43"
    }
  }

  # We don't need to maintain state right now as the project is not yet deployd
  #  backend "s3" {
  #    bucket         = "my-terraform-state-bucket"
  #    key            = "${var.app_name}/terraform.tfstate"
  #    region         = var.region
  #    dynamodb_table = "terraform-lock"
  #  }
  required_version = ">= 1.7.5"
}
