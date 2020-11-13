locals {
  aggregate_public_subnets  = concat(aws_subnet.public.*.id, aws_subnet.rancher_eks.*.id)
  aggregate_private_subnets = concat(aws_subnet.private.*.id, aws_subnet.private_prod_lambda.*.id, aws_subnet.private_test_lambda.*.id)
}
