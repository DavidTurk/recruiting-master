# APP Module Input Varialbles

variable "app_ami" {
  description = "The ami to use for the application instance."
  type        = string
}

variable "app_instance_type" {
  description = "The instance type to use for the application instance."
  type        = string
}

variable "app_vpc_id" {
  description = "Output from VPC Module: the ID of the VPC."
  type        = string
}

variable "app_subnet" {
  description = "Output from Subnets Module: the ID of the public subnet."
  type        = string
}

variable "app_provisioning_key" {
  description = "A key that can be used to connect and provision instances in AWS."
  type        = string
}

variable "app_associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC. Boolean value."
  type        = bool
}

variable "app_mongo_address" {
  description = "Output from Mongo Module: the IP address of the Mongo instance."
  type        = string
}

variable "app_tags" {
  description = "App metadata."
  default     = {}
  type        = map(string)
}