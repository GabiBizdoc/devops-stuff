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

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "a-simple-lambda"
}

variable "app_domain_name" {
  description = "Custom domain name for the application"
  type        = string
}

variable "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
}

variable "api_stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "test"
}