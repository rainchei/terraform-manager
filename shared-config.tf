terraform {
  required_version = ">= 1.1.7"
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "random" {}

provider "local" {}

provider "null" {}

provider "template" {}
