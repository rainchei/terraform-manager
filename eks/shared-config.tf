terraform {
  required_version = ">= 0.14.4"
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "random" {}

provider "local" {}

provider "null" {}

provider "template" {}
