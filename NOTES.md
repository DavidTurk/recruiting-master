## Getting Started

### Required cli tools
- `awscli`
- `terraform`

### Assumptions
1. You have installed the required tools above.
1. You have an AWS account and permission to create resources.
1. You have a 'logikcull-test' profile in your `~/.aws/config` file and can authenticate with AWS/`awscli`
1. If troubleshooting/SSH: You have an SSH keypair in your `~/.ssh/` directory named `main_ssh_key` and `main_ssh_key.pub`

### Step-by-step instructions
1. Clone this repository locally.
1. `cd` into the /environments/test directory
1. run `terraform init` to initialize
1. run `terraform apply` to see the plan and then type 'yes' if you wish to create the stack
1. upon successful creation of all resources, copy the public IP from the output and paste into a web browser: http://{app_public_ip}:8080/test.htm

### Troubleshooting
1. If the above doesn't work there are two likely points for issue: 
1. **App instance**
   1. Copy the app's public IP and from the output as before as well as Mongo's private IP and SSH to the APP instance: `ssh -A -i {path/to/key} ubuntu@{app_public_ip}`
   1. Ensure the cloud init/user data script worked correctly: `cat /var/log/cloud-init-output.log`
      1. You could also check for ruby instances: `ps aux | grep ruby`
   1. If it is not running, start Sinatra: `nohup ruby /home/ubuntu/app.rb &`
   1. If it is running, check ensure Mongo is reachable: `telnet {mongo_private_ip} 27017`
1. **Mongo instance**
   1. Copy the app's public IP and from the output as before as well as Mongo's private IP  and SSH to the APP instance: `ssh -A -i {path/to/key} ubuntu@{app_public_ip}`
   1. SSH to the Mongo instance from the APP instance: `ssh -A {mongo_private_ip}`
   1. Ensure the cloud init/user data script worked correctly: `cat /var/log/ cloud-init-output.log`
   1. If it has not worked, try reimporting: 
      1. `wget --quiet https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/  primer-dataset.json`
      1. `mongoimport --db example_data --collection restaurants --drop --file primer-dataset.json`

___

## From instructions.md

### Terraform stands up a functional environment - Can we run your code and stand up a new stack?
    Yes

### The Application code works - Hitting the `/query` endpoint returns the correct result from the MongoDB sample data set.
    Yes:
    {record_count: 25359}

### Useful outputs - When the build completes, is the output helpful and relevant?
    The terraform apply will output the public IP of the APP instance as well as the private IP of the Mongo primary instance. It could likely use more improvements (see below).

### Written communication - Does your solution include documentation that describes your solution, tips for the reviewer, and any difficulties faced?
    This file has been created for this.

## Opportunities for extension or modification
    We'd love to discuss how we can change this environment for the better, how it might change with scale, etc. Keep these in mind as you work and make a note of any great ideas!

### Improvements, time, and the like
The assignment asked to take no more than 4 hours, which I don't think I quite accomplished. As such, I didn't have time to make improvements or fix any of the issues I caused. Some likely points for improvement are:
- Fixing the glaring SSH hole I opened to the public internet on the APP instance. :)
- Using the `provisioning_key` variable. In the interest of simplicity and time I just placed the init scripts in the `user_data` field and let AWS take care of it.
- Using the second private subnet. Likely an additional Mongo instance should go here (`mongo_count` > 1), as it stands this subnet exists but sits empty.
- Along with the above, increasing the number of public subnets (and likely NAT Gateways) to >1 so all private subnets don't lose connectivity to the NAT Gateway in the unlikely even of an AZ outage.
- Adding additional APP instances (and load balancing). Same with Mongo instances. This is likely necessary for scaling in the longer term.
- Implement some form of caching if necessary to reduce load on the DB.
- Authentication? Is the data sensitive? Do we need to limit access to various parts of our APP?
- Deployment/Terraform should likely run from a CI/CD-type pipeline instead of local machines. The tf state file should be centralized similarly.
- Any secrets or keys should be centralized in something like `Secrets Manager` or `Vault`
- And I'm sure there are many more things