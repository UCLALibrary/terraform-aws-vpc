# terraform-aws-vpc ![Lint and validate](https://github.com/UCLALibrary/terraform-aws-vpc/workflows/Lint%20and%20validate/badge.svg)

## Description
This module will instantiate an AWS account that can be configured in variations of the following:

* Non-default VPC
* Public Subnets
** Routable through NAT Gateway
* Public Subnets with NAT routes configured
** Matched destinations will route using NAT, otherwise use Internet Gateway
* Private Subnets
** Not routable outside of VPC network
** Can attach NAT for external routes


## Usage
The following variables are required to use this module:

### Public subnet requirements

#### Required
vpc_cidr
create_igw
public_subnets
name

#### Optional
tags
vpc_tags
public_subnet_tags
public_route_table_tags

### Private subnets requirements

#### Required
vpc_cidr
private_subnets
name

#### Optional
tags
vpc_tags
private_subnet_tags
private_route_table_tags

### Public subnets with NAT destination routes

#### Required
vpc_cidr
public_subnets
private_subnets
single_nat_gateway
name

#### Optional
tags
vpc_tags
public_subnet_tags
private_subnet_tags
nat_gateway_tags
nat_eip_tags
public_route_table_tags
private_route_table_tags
