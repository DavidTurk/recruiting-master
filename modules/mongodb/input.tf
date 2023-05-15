# MongoDB Module Input Varialbles

variable "mongo_count" {
  description = "How many mongodb instances to create."
  type        = number
}

variable "mongo_ami" {
  description = "The ami to use for the mongodb instance."
  type        = string
}

variable "mongo_instance_type" {
  description = "The instance type to use for the mongodb instance."
  type        = string
}

variable "mongo_vpc_id" {
  description = "Output from VPC Module: the ID of the VPC."
  type        = string
}

variable "mongo_subnet" {
  description = "Output from Subnets Module: the ID of the primary private subnet."
  type        = string
}

variable "mongo_app_sg" {
  description = "Output from App Module: the ID of the security group."
  type        = string
}

variable "mongo_volume_type" {
  description = "The volume type to use for data storage on the mongodb instance."
  type        = string
}

variable "mongo_volume_size" {
  description = "The volume size to use for the mongodb instance."
  type        = number
}

variable "mongo_provisioning_key" {
  description = "A key that can be used to connect and provision instances in AWS."
  type        = string
}

variable "mongo_tags" {
  description = "Mongodb metadata"
  default     = {}
  type        = map(string)
}