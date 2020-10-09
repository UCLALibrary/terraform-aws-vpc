output "vpc_id" {
  value = aws_vpc.this[0].id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "nat_public_ip" {
  value = aws_nat_gateway.this[0].public_ip
}
