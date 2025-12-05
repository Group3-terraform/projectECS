📘 Terraform Project — ECS Microservices with ALB, HTTPS, ACM, Route53 (DEV + UAT)

This project deploys a complete AWS infrastructure for microservices using:

Amazon ECS (Fargate)

Application Load Balancer (HTTPS)

ACM SSL Certificate

Route53 DNS

VPC with Public + Private Subnets

Multi-environment support (DEV + UAT)

Reusable Terraform modules

🚀 Architecture Overview
Client → HTTPS (api.dev.theareak.click / api.uat.theareak.click)
          │
          ▼
   Application Load Balancer
          │
     Path routing rules:
     /a → service A (Fargate)
     /b → service B (Fargate)
     /c → service C (Fargate)
          │
          ▼
      ECS Cluster (Fargate Tasks)

📁 Project Structure
project/
├── backend.tf
├── modules/
│   ├── vpc/
│   ├── security/
│   ├── iam/
│   ├── acm/
│   ├── route53/
│   ├── alb/
│   └── ecs/
│
├── envs/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   │
│   └── uat/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
└── README.md

🌍 Domains & Routing
Environment	Base Domain	Services
DEV	api.dev.theareak.click	/a, /b, /c
UAT	api.uat.theareak.click	/a, /b, /c

Path routing example:

https://api.dev.theareak.click/a → service A
https://api.dev.theareak.click/b → service B
https://api.dev.theareak.click/c → service C

🔑 Requirements

Before running Terraform:

1. Install tools
Terraform ≥ 1.6
AWS CLI v2

2. Configure AWS credentials
aws configure

3. Create S3 bucket + DynamoDB table for backend

Example bucket name:

group3-tfstate-dev


DynamoDB table name:

terraform-locks

⚙️ How to Deploy (DEV or UAT)
1️⃣ Go to environment folder
DEV
cd envs/dev

UAT
cd envs/uat

2️⃣ Initialize Terraform
terraform init


This loads all modules + backend config.

3️⃣ Validate & Plan
terraform plan

4️⃣ Apply infrastructure
terraform apply -auto-approve


This will:

✔ Create VPC
✔ Create ECS Cluster
✔ Create three ECS services (A/B/C)
✔ Create ALB (HTTPS)
✔ Create ACM SSL certificate
✔ Create Route53 DNS records
✔ Deploy microservices using ECR images

🐳 Setting ECR Images

Each environment uses values from terraform.tfvars.

Example:

service_a_image = "570430250751.dkr.ecr.ap-southeast-1.amazonaws.com/service-a:dev-v1.0.7"
service_b_image = "570430250751.dkr.ecr.ap-southeast-1.amazonaws.com/service-b:dev-v1.0.7"
service_c_image = "570430250751.dkr.ecr.ap-southeast-1.amazonaws.com/service-c:dev-v1.0.7"


UAT can use its own tags.

🧪 Testing After Deploy
Check ALB DNS
terraform output alb_dns_name

Test service A
curl -i https://api.dev.theareak.click/a

Test service B
curl -i https://api.dev.theareak.click/b

🔄 Destroy Environments

To delete everything:

terraform destroy


Environment must be destroyed separately:

envs/dev

envs/uat

🧱 Modules Explanation
modules/vpc

Creates VPC, IGW, NAT, public & private subnets.

modules/security

Security groups for ALB + ECS Tasks.

modules/iam

ECS execution role + service task role.

modules/acm

Provision SSL Certificate for environment subdomain.

modules/route53

Create DNS A-record → ALB.

modules/alb

ALB + listener + listener rules + target groups.

modules/ecs

ECS Cluster + 3 ECS Services + Task Definitions.

📌 Notes

Terraform automatically attaches ECS services to ALB.

Terraform automatically creates path-based routing.

ACM certificates are validated via DNS (auto).

Route53 record is created after ALB is ready.

🎉 You’re Ready to Deploy!

Your structure is fully production-ready:

✔ Multi-environment
✔ Modular
✔ HTTPS
✔ Load balanced
✔ Autoscaling-ready
✔ ECR-integrated