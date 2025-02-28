terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr_block = "10.1.0.0/16"
  tag = {
    Environment = "dev"
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "my-eks-cluster"
  subnet_ids         = concat(module.networking.private_subnet_ids, module.networking.public_subnet_ids)
  security_group_id  = module.networking.eks_security_group_id
  kubernetes_version = "1.27"
  tags = {
    Environment = "development"
    Project     = "eks-demo"
  }
}

module "node_group" {
  source       = "./modules/node_group"
  cluster_name = module.eks.cluster_name
  subnet_ids   = concat(module.networking.private_subnet_ids, module.networking.public_subnet_ids)
  tags = {
    Environment = "Dev"
  }
}
