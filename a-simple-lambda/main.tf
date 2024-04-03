# Define the AWS provider with region and profile configurations
provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43"
    }
  }

# We don't need this right now.
#  backend "s3" {
#    bucket         = "my-terraform-state-bucket"
#    key            = "${var.app_name}/terraform.tfstate"
#    region         = var.region
#    dynamodb_table = "terraform-lock"
#  }
  required_version = ">= 1.7.5"
}
