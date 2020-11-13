output "vpc_id" {
  value = aws_vpc.this[0].id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "private_eks_nodegroup_subnet_ids" {
  value = aws_subnet.private_eks_nodegroup.*.id
}

output "private_prod_lambda_subnet_ids" {
  value = aws_subnet.private_prod_lambda.*.id
}

output "private_test_lambda_subnet_ids" {
  value = aws_subnet.private_test_lambda.*.id
}

output "public_eks_control_subnet_ids" {
  value = aws_subnet.public_eks_control.*.id
}

output "rancher_eks_subnet_ids" {
  value = aws_subnet.rancher_eks.*.id
}

output "nat_public_ip" {
  value = aws_nat_gateway.this[0].public_ip
}
