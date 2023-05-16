#################################################
# Main Security Group
#################################################
resource "aws_security_group" "main" {
    vpc_id = var.mongo_vpc_id

    ingress {
      from_port   = 27000
      to_port     = 28000
      protocol    = "tcp"
      security_groups = ["${var.mongo_app_sg}"]
    }

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      security_groups = ["${var.mongo_app_sg}"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.mongo_tags, { Name = "terraform-sg-mongodb"})
}

# Mongo user_data setup
data "template_file" "user_data" {
  template = file("${path.module}/files/user_data.sh")
}

#################################################
# Main Mongodb
#################################################
resource "aws_instance" "main" {
    count = var.mongo_count
    ami = var.mongo_ami
    instance_type = var.mongo_instance_type
    subnet_id = var.mongo_subnet
    vpc_security_group_ids = ["${aws_security_group.main.id}"]
    key_name = var.mongo_provisioning_key

    ebs_block_device {
      device_name = "/dev/xvdb"
      volume_type = var.mongo_volume_type
      volume_size = var.mongo_volume_size
    }

    user_data = data.template_file.user_data.rendered

    tags = merge(var.mongo_tags, { Name = "terraform-instance-mongodb-${count.index + 1}"})
}