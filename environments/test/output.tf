# Create helpful outputs here..

output "vpc_id" { value = module.vpc.vpc_id }
output "vpc_cidr" { value = module.vpc.vpc_cidr }
output "mongo_private_ip" { value = module.mongodb.mongo_private_ip }
output "app_public_ip" { value = module.app.app_public_ip }

# output for app public ip address..?