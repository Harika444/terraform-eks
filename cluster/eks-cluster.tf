data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "Harika"
    workspaces = {
      name = "my-SG"
    }
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = data.terraform_remote_state.cluster.outputs.cluster_name
  cluster_version = "1.20"
  subnets         = data.terraform_remote_state.cluster.outputs.private_subnets

  tags = {
    Environment = "learning"
  }

  vpc_id = data.terraform_remote_state.cluster.outputs.vpc_id
  workers_group_defaults = {
    root_volume_type = "gp2"
    root_volume_size     = 8
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 1
      additional_security_group_ids = data.terraform_remote_state.cluster.outputs.worker_security_group_id
    },
  ]
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.18-v*"]
  }

  most_recent = true

  owners = ["amazon"]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "Endpoint for EKS control plane."
  value       = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}


output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}