# Create helpful outputs here..

output "vpc_id" { value = module.vpc.vpc_id }
output "vpc_cidr" { value = module.vpc.vpc_cidr }

# output for app public ip address..?