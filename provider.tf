terraform {
  required_providers {
    aws = "> 5.0"
  }
}


provider "aws" {
  region = var.region
}
