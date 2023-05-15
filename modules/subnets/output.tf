output "public_subnet_id" { value = aws_subnet.public_subnets[0].id}
output "private_primary_subnet_id" { value = aws_subnet.public_subnets[0].id}