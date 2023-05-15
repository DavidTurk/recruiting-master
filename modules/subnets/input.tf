# Subnets Module Input Varialbles

variable "subnets_target_vpc_id" {
  description = "Output from VPC Module: the ID of the VPC."
  type        = string
}

variable "subnets_target_vpc_igw_id" {
  description = "Output from VPC Module: the ID of the Internet Gateway."
  type        = string
}

variable "subnets_public_cidrs" {
 type        = list(string)
 description = "Public subnet CIDRs."
 default     = ["10.9.1.0/24", "10.9.2.0/24", "10.9.3.0/24"]
}

variable "subnets_private_cidrs" {
 type        = list(string)
 description = "Private subnet CIDRs."
 default     = ["10.9.4.0/24", "10.9.5.0/24", "10.9.6.0/24"]
}

variable "subnets_az_state_filter" {
  description = "This value can be used to filter Availability Zones to use when setting up network resources."
  type        = string
}

variable "subnets_private_count" {
  description = "How many private subnets to make."
  type        = number
}

variable "subnets_public_count" {
  description = "How many public subnets to make."
  type        = number
}

variable "subnets_enable_nat_gateway" {
  description = "A boolean flag to enable/disable the creation of a NAT Gateway."
  type        = bool
}

variable "subnets_tags" {
  description = "Subnets metadata."
  default     = {}
  type        = map(string)
}