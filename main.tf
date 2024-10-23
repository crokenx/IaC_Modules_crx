provider "aws" {
  profile = "dev-local"
  region  = "us-east-1"
}

# Implementación del módulo VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  subnet_a_cidr      = "10.0.1.0/24"
  subnet_b_cidr      = "10.0.2.0/24"
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags = {
    Name = "Main VPC"
  }
}

# Implementación del módulo IGW y Routing
module "igw_and_routing" {
  source     = "./modules/igw_and_routing"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids

  depends_on = [module.vpc]
}

# Implementación del módulo Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

# Implementación del módulo IAM Roles
module "iam_roles" {
  source = "./modules/iam_roles"
  role_name = "ecsTaskExecutionRole"
}

# Implementación del módulo ALB
module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.subnet_ids
  security_group = module.security_groups.alb_sg_id
  capacity       = "franchise"

  depends_on = [module.security_groups]
}

# Implementación del módulo ECR
module "ecr" {
  source = "./modules/ecr"
  repository_name = "test-franchise-ms"
}


# Implementación del módulo RDS
module "rds" {
  source         = "./modules/rds"
  subnet_ids     = module.vpc.subnet_ids
  security_group = module.security_groups.rds_sg_id
  capacity       = "franchise"
  db_username    = "test"
  db_password    = "123456789"

  depends_on = [module.vpc,module.security_groups]
}


# Implementación del módulo ECS
module "ecs" {
  source                    = "./modules/ecs"
  task_execution_role_arn   = module.iam_roles.task_execution_role_arn
  security_group            = module.security_groups.ecs_sg_id
  subnets                   = module.vpc.subnet_ids
  alb_target_group_arn      = module.alb.target_group_arn
  ecr_repository_url        = module.ecr.repository_url
  rds_endpoint              = module.rds.rds_endpoint
  capacity                  = "franchise"
  db_username               = "test" //deberia ir en un secreto
  db_password               = "123456789"//deberia ir en un secreto
  db_name                   = "franchisedb"//deberia ir en un secreto

  depends_on = [module.rds,module.ecr]
}
