#################################################
# Main App
#################################################
resource "aws_instance" "main" {
    ami = var.app_ami
    instance_type = var.app_instance_type
    subnet_id = var.app_subnet
    
    tags = merge(var.app_tags, { Name = "terraform-instance-app"})
}

#################################################
# Main Security Group
#################################################
resource "aws_security_group" "main" {

    tags = merge(var.app_tags, { Name = "terraform-sg-app"})
}