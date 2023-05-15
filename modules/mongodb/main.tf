#################################################
# Main Mongodb
#################################################
resource "aws_instance" "main" {
    ami = var.mongo_ami
    instance_type = var.mongo_instance_type
    subnet_id = var.mongo_subnet
    
    tags = merge(var.mongo_tags, { Name = "terraform-instance-mongodb"})
}