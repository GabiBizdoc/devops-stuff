variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-central-1"
}

variable "profile" {
  description = "AWS profile to use for deployment"
  type        = string
  default     = "dev_profile"
}

variable "app_tag" {
  description = "Default tag to be applied to resources"
  type        = string
  default     = "lambda-stack"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "a-simple-lambda"
}

variable "domain_name" {
  description = "Domain of the application"
  type        = string
}

variable "zone_id" {
  description = "Value of zone id"
  type        = string
}

variable "stage_name" {
  description = "Value of stage_name"
  type        = string
  default     = "test"
}