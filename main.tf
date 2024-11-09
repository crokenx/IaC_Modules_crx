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
}

# Implementación del módulo IGW y Routing
module "igw_and_routing" {
  source     = "./modules/igw_and_routing"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids

  depends_on = [module.vpc]
}


# Implementación del módulo IAM Roles ECS
module "iam_roles_ecs" {
  source = "./modules/iam_roles/ecs"
  role_name = "ecsTaskExecutionRole"
}

# Implementación del módulo IAM Roles EKS
module "iam_roles_eks" {
  source                = "./modules/iam_roles/eks"
  role_eks_cluster_name = "eksClusterRole"
  role_eks_node_name    = "eksNodeRole"
}

# Implementación del módulo ALB
module "alb" {
  source         = "./modules/alb"
  subnets        = module.vpc.subnet_ids
  capacity       = "franchise"

  depends_on = [module.vpc]
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
  capacity       = "franchise"
  db_username    = "test"
  db_password    = "123456789"

  depends_on = [module.vpc]
}

# Implementación del módulo ECS
module "ecs" {
  source                    = "./modules/ecs"
  task_execution_role_arn   = module.iam_roles_ecs.task_execution_role_arn
  subnets                   = module.vpc.subnet_ids
  alb_target_group_arn      = module.alb.target_group_arn
  ecr_repository_url        = module.ecr.repository_url
  rds_endpoint              = module.rds.rds_endpoint
  capacity                  = "franchise"
  db_username               = "test" //deberia ir en un secreto
  db_password               = "123456789"//deberia ir en un secreto
  db_name                   = "franchisedb"//deberia ir en un secreto

  depends_on = [module.rds,module.ecr,module.alb]
}


# Implementación del módulo EKS
module "eks" {
  source              = "./modules/eks"
  cluster_name        = "franchise-eks-cluster"
  node_group_name     = "franchise-node-group"
  cluster_role_arn    = module.iam_roles_eks.task_execution_role_eks_cluster_arn
  node_role_arn       = module.iam_roles_eks.task_execution_role_eks_node_arn
  subnet_ids          = module.vpc.subnet_ids
  desired_size        = 2
  max_size            = 3
  min_size            = 1
}
