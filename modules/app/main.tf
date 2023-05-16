#################################################
# Main Security Group
#################################################
resource "aws_security_group" "main" {
  vpc_id = var.app_vpc_id
  
  ingress {
      description = "SSH from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP ruby/sinatra from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    tags = merge(var.app_tags, { Name = "terraform-sg-app"})
}

# App user_data setup
data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = { mongo_address = "${var.app_mongo_address}"}
}

#################################################
# Main App
#################################################
resource "aws_instance" "main" {
    ami = var.app_ami
    instance_type = var.app_instance_type
    subnet_id = var.app_subnet
    associate_public_ip_address = var.app_associate_public_ip_address
    vpc_security_group_ids = ["${aws_security_group.main.id}"]
    key_name = var.app_provisioning_key

    user_data = data.template_file.user_data.rendered
    
    tags = merge(var.app_tags, { Name = "terraform-instance-app"})
}