A Basic Three-Tier AWS Infrastructure Provisioning with Terraform
This project uses Terraform to provision a highly available and scalable AWS infrastructure for a web and application stack. It supports a multi-tier architecture comprising VPCs, subnets, EC2 instances, RDS databases, security groups, autoscaling, and load balancing.
________________________________________
Architecture Overview
The infrastructure consists of:
1.	A VPC with:
o	Two public subnets for web servers.
o	Four private subnets for app servers and RDS database.
2.	An Internet Gateway for internet connectivity of public subnets.
3.	A NAT Gateway for app servers to access the internet without exposing them publicly.
4.	EC2 Instances:
o	Two web servers in public subnets.
o	Two app servers in private subnets.
5.	RDS MySQL Database hosted in private subnets with restricted access.
6.	Load Balancers:
o	Application Load Balancer (ALB) for web tier.
o	Application Load Balancer (ALB) for app tier.
7.	Autoscaling Groups for web and app servers to maintain scalability.
8.	Security Groups to control inbound and outbound traffic.
________________________________________
Prerequisites
1.	AWS Account with permissions to create resources like VPCs, EC2 instances, RDS databases, etc.
2.	Terraform CLI installed on your local machine (version 1.0 or later recommended).
3.	Key Pair for SSH access to EC2 instances. The key is generated within the configuration, and the private key is stored locally.
________________________________________
Getting Started
1. Clone the Repository
git clone https://github.com/Ernieblack/Basic-Terraform-Three-Tier.git
cd Terraform-three-tier-web
2. Initialize Terraform
Run the following command to initialize the Terraform working directory and download necessary provider plugins:
terraform init
3. Review and Apply Configuration
•	Review the configuration files to ensure they meet your requirements.
•	Apply the configuration to provision resources:
terraform apply
Type yes when prompted to confirm.
4. Clean Up Resources
To delete all resources created by this configuration, run:
terraform destroy
________________________________________
Infrastructure Components
VPC and Subnets
•	A single VPC is created with CIDR 10.0.0.0/16.
•	Two public subnets and four private subnets span across two availability zones.
Instances
•	Web servers are provisioned in public subnets with a user data script to configure web applications.
•	App servers are provisioned in private subnets and connected to an internal load balancer.
•	RDS MySQL database is configured in private subnets with high availability.
Load Balancers
•	Two ALBs (for web and app tiers) distribute traffic to respective target groups.
Security Groups
•	Security groups are configured to allow: 
o	HTTP traffic to web servers.
o	MySQL access from app servers to the database.
o	Communication between web, app, and database layers.
Autoscaling
•	Autoscaling groups maintain the desired number of instances based on scaling policies.
________________________________________
Usage
Key Pair
The Terraform configuration generates an RSA key pair:
•	The private key is stored locally in a file named webkp.
•	Use the key to SSH into EC2 instances.
User Data Scripts
The web servers and app servers can be configured using user data scripts specified in user_data.tpl and user_data1.tpl.
Load Balancer
The load balancers route traffic to the EC2 instances. Ensure the target health checks are configured correctly.
RDS Database
The MySQL database uses the admin user with the password ernie1235#. Modify these values if needed in the aws_db_instance resource.

Automation
A jenkinsfile for automating the build, test and deployment process within Jenkins.

