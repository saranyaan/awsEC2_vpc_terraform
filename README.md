# awsEC2_vpc_terraform
Launching an ec2 instance in aws cloud inside a vpc using terraform code
1. Terraform aws provider configuration (region given as "us-east-1")
2. Create VPC
3. Attach IGW to VPC
4. Create a Public subnet inside VPC with a cidr block of 10.0.1.0/24 (255 ips)
5. Ensures any EC2 instance launched here automatically gets a public IP
6. Creates a route table to direct all outbound traffic (0.0.0.0/0) through the IGW
7. Links the route table with the public subnet to give it internet access
8. create security groups and traffic rules
9. Launches an Amazon Linux 2 EC2 instance using t2.micro
10. Places the instance in the public subnet
11. Attaches the security group to allow access.Associates your Key Pair for SSH login
12. Automatically gets a public IP so you can connect to it

terraform init

terraform plan

terraform plan -out=tfplan

terraform show -json tfplan > plan.json (store plan file as json file)

terraform apply tfplan
