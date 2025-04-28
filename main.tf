terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "029DA-DevOps24"
    
    workspaces {
        prefix = "network-"
    }
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

provider "aws" {}

module "billing_alert" {
    source = "binbashar/cost-billing-alarm/aws"
    create_sns_topic = true
    aws_env = "029DO-FA24"
    monthly_billing_threshold = 5
    currency = "USD"
}
output "sns_topic_arn" {
    value = "${module.billing_alert.sns_topic_arns}"
}
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    
    name = "my_vpc"
    cidr = "10.0.0.0/16"
    azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    enable_nat_gateway = true
    enable_vpn_gateway = true
    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}