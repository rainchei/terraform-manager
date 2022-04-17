variable "eks_cluster_name" {}
variable "eks_cluster_version" {}
variable "eks_vpc_id" {}
variable "eks_subnets" {}
variable "eks_api_public_access" {}
variable "eks_manage_aws_auth" {}
variable "eks_map_roles" {}
variable "eks_node_group_capacity_type" {}
variable "eks_node_group_instance_types" {}
variable "eks_node_group_asg_desire" {}
variable "eks_node_group_asg_max" {}
variable "eks_node_group_asg_min" {}
variable "eks_node_group_additional_sg" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = var.eks_cluster_name
  cluster_version                      = var.eks_cluster_version
  vpc_id                               = var.eks_vpc_id
  subnets                              = var.eks_subnets
  cluster_endpoint_public_access_cidrs = var.eks_api_public_access
  manage_aws_auth                      = var.eks_manage_aws_auth
  map_roles                            = var.eks_map_roles
  tags = {
    Environment = var.env
  }

  node_groups = {
    default = {
      capacity_type           = var.eks_node_group_capacity_type
      instance_types          = var.eks_node_group_instance_types
      desired_capacity        = var.eks_node_group_asg_desire
      max_capacity            = var.eks_node_group_asg_max
      min_capacity            = var.eks_node_group_asg_min
      launch_template_id      = aws_launch_template.eks_node_group.id
      launch_template_version = aws_launch_template.eks_node_group.default_version
      k8s_labels = {
        Environment = var.env
      }
      additional_tags = {
        Name = "${var.eks_cluster_name}-managed-nodes"
      }
    }
  }
}

resource "aws_launch_template" "eks_node_group" {
  name_prefix            = "eks-node-group"
  description            = "Launch-Template for EKS Node Group"
  update_default_version = true
  tags = {
    Environment = var.env
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 100
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups = [
      module.eks.worker_security_group_id,
      var.eks_node_group_additional_sg
    ]
  }
  monitoring {
    enabled = true
  }
  lifecycle {
    create_before_destroy = true
  }

  # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.eks_cluster_name}-managed-nodes"
      Environment = var.env
    }
  }
  # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC tho)
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "${var.eks_cluster_name}-managed-nodes"
      Environment = var.env
    }
  }
}
