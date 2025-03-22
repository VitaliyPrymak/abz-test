# WordPress Infrastructure Deployment

## Overview
This project provides Terraform configurations to deploy the necessary AWS infrastructure for a WordPress application. The infrastructure includes networking components, security groups, an EC2 instance, a database (RDS), and a caching layer (Redis).  

The deployment was executed using `deployment.sh`, which was present on the server and handled provisioning the infrastructure automatically.

## Configuration Options
To customize the deployment, modify the following Terraform variables in `terraform.tfvars`:

- **AWS Region**: Set the desired AWS region.
- **Instance Type**: Define the type of EC2 instance for WordPress.
- **Database Settings**: Configure the RDS instance type, storage size, and credentials.
- **VPC & Subnets**: Specify CIDR ranges for the network.
- **Security Group Rules**: Adjust inbound and outbound rules for EC2 and RDS.

## Deployment Steps
1. **Initialize Terraform**  
   ```sh
   terraform init
   ```
2. **Validate Configuration**  
   ```sh
   terraform validate
   ```
3. **Plan Deployment**  
   ```sh
   terraform plan
   ```
4. **Apply Changes**  
   ```sh
   terraform apply -auto-approve
   ```
5. **Access the WordPress Instance**  
   Retrieve the public IP from the Terraform output and access the WordPress installation via the browser.

## Troubleshooting & Common Issues
- **Permission Errors**: Ensure your AWS credentials are correctly set up in `~/.aws/credentials`.
- **Terraform State Issues**: If `terraform.tfstate` gets corrupted, manually remove it and reinitialize Terraform.
- **Security Group Issues**: If unable to access the instance, verify that port `80` (HTTP) and `22` (SSH) are open in the security group.
- **Module Issues**: If an external Terraform module fails to load, run `terraform get -update` to refresh modules.

## External Modules & Tools Used
- **Terraform AWS VPC Module** – Used to create a structured and reusable VPC setup.
- **Terraform AWS Security Group Module** – Simplifies managing security rules.
- **Terraform AWS RDS Module** – Manages database provisioning efficiently.

## Code Structure
```
/terraform/modules
│── alb.tf                 # Application Load Balancer Configuration
│── ec2.tf                 # EC2 Instance Configuration
│── iam.tf                 # IAM Roles and Policies (Sensitive, not committed)
│── outputs.tf             # Outputs for Infrastructure (Sensitive, not committed)
│── provider.tf            # AWS Provider Configuration
│── rds.tf                 # RDS Database Configuration
│── redis.tf               # Redis Cache Configuration
│── route_tables.tf        # Route Tables Configuration
│── security_groups.tf     # Security Groups Configuration
│── templates/user-data.sh # EC2 User Data Script for Bootstrapping
│── variables.tf           # Terraform Variables
│── vpc.tf                 # Virtual Private Cloud (VPC) Configuration
```

## Additional Notes
- The deployment script (`deployment.sh`) was used on the server to automate the deployment.
- Sensitive files (`iam.tf` and `outputs.tf`) were intentionally excluded from version control for security reasons.

