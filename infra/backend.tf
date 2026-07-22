terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state: nhiều người / CI cùng dùng 1 state file an toàn nhờ S3 + DynamoDB lock.
  # Điền đúng tên bucket/table sau khi bootstrap apply xong.
  backend "s3" {
    bucket         = "minhtri-practice-tfstate-2026"
    key            = "infra/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "practice-terraform"
      ManagedBy = "terraform"
    }
  }
}
