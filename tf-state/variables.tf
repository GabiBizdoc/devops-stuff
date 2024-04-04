variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS profile to use for deployment"
  type        = string
  default     = "dev_profile"
}

variable "aws_s3_backend" {
  description = "Name of the S3 bucket where state will be stored"
  type        = string
}