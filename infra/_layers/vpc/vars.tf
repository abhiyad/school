variable "cidr" {
  description = "CIDR block for ayadav VPC"
  default     = "40.10.0.0/16"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for ayadav VPC"
  default     = "40.10.0.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for ayadav VPC"
  default     = "40.10.1.0/24"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for ayadav VPC"
  default     = "40.10.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for ayadav VPC"
  default     = "40.10.3.0/24"
}

variable "aws_account_id" {
  description = "account id of ml-dev"
  default     = "385353112324"
}

variable "region" {
  description = "account id of ml-dev"
  default     = "us-east-2"
}

variable "vpc_name" {
  description = "VPC name for ml-dev"
  default     = "ml-dev-ayadav-vpc"
}