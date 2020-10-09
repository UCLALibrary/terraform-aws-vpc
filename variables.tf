#################
# AWS Settings
#################
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

#################
# Tags
#################
variable "name" {
  description = "The prefix to all tags in executed in this module"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for public subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_suffix" {
  description = "Suffix tag for public subnets"
  type        = string
  default     = "public"
}

variable "public_route_table_tags" {
  description = "Additional tags for public route tables"
  type        = map(string)
  default     = {}
}


variable "private_subnet_tags" {
  description = "Additional tags for private subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_suffix" {
  description = "Suffix tag for private subnets"
  type        = string
  default     = "private"
}

variable "private_route_table_tags" {
  description = "Additional tags for private route tables"
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = "Additional tags for NAT EIP"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Additional tags for NAT gateway"
  type        = map(string)
  default     = {}
}

#################
# VPC
#################
variable "create_vpc" {
  description = "Controls if VPC should be created"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The string value of your VPC CIDR block, must be class B or C"
  type        = string
  default     = "172.32.0.0/16"
}

variable "enable_dns_support" {
  description = "Controls if DNS support is allowed in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Controls if DNS hostnames is allowed in VPC"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable IPV6, currently not supported in module. do not change this value"
  type        = bool
  default     = false
}

#################
# Subnets
#################
variable "azs" {
  description = "Availability zones in the corresponding region for subnet deployment"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = []
}

variable "enable_map_public_ip_launch" {
  description = "Allow public subnet to map public IP on launch"
  type        = bool
  default     = true
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = []
}

##################
# Internet Gateway
##################
variable "create_igw" {
  description = "Controls if igw should be created"
  type        = bool
  default     = true
}

#################
# NAT Gateway
#################
variable "single_nat_gateway" {
  description = "Controls if a single NAT gateway is created"
  type        = bool
  default     = false
}

#################
# Private Route Table
#################
variable "nat_destinations" {
  description = "List of NAT destinations for NAT gateway"
  type        = list(string)
  default     = []
}

#################
# S3 VPC Endpoint
#################
variable "enable_s3_endpoint" {
  description = "Controls if an S3 VPC endpoint is created"
  type        = bool
  default     = true
}

variable "s3_vpc_endpoint" {
  description = "AWS Endpoint to set VPC endpoint"
  type        = string
  default     = null
}
