output "app_sg_id" { value = aws_security_group.main.id }
output "app_public_ip" { value = aws_instance.main.public_ip }