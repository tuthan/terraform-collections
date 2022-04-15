terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70"
    }
  }
}

provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  alias                   = "primary"
}
