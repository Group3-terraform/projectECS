project_name = "group3"
environment  = "dev"
region       = "ap-southeast-1"

domain  = "api.dev.theareak.click"
zone_id = "Z07852252OWMU8O090PPL"

service_a_image = "570430250751.dkr.ecr.ap-southeast-1.amazonaws.com/service-a:dev-v1.0.7"
service_b_image = "570430250751.dkr.ecr.ap-southeast-1.amazonaws.com/service-b:dev-v1.0.7"
service_c_image = "570430250751.dkr.ecr.ap-southeast-1.amazonaws.com/service-c:dev-v1.0.7"

vpc_cidr = "10.0.0.0/16"

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

azs = ["ap-southeast-1a", "ap-southeast-1b"]
