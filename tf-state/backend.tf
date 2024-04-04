terraform {
  backend "s3" {
    encrypt = true
    config_file = "backend.conf"
  }
}