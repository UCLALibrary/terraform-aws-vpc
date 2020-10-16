locals {
  aggregate_public_subnets  = concat(aws_subnet.public.*.id, aws_subnet.public_eks_control.*.id)
  aggregate_private_subnets = concat(aws_subnet.private.*.id, aws_subnet.private_lambda.*.id, aws_subnet.private_eks_nodegroup.*.id)
}
