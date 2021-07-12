data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "Harika"
    workspaces = {
      name = "my-VPC"
    }
  }
}

resource "aws_security_group" "worker_group" {
  name   = "worker_group_node"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "worker_security_group_id" {
  description = "Security group ids attached to the worker node."
  value       = [aws_security_group.worker_group.id]
}

output "vpc_id" {
  description = "VPC ID."
  value       = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "private_subnets" {
  description = "VPC ID."
  value       = data.terraform_remote_state.vpc.outputs.private_subnets
}

output "cluster_name" {
  description = "cluster name"
  value       = data.terraform_remote_state.vpc.outputs.cluster_name
}