variable "eks_cluster_name" {}
variable "eks_cluster_version" {}
variable "eks_cluster_endpoint_public_access" {}
variable "eks_cluster_endpoint_public_access_cidrs" {}
variable "eks_vpc_id" {}
variable "eks_subnet_ids" {}
variable "eks_manage_aws_auth_configmap" {}
variable "eks_aws_auth_roles" {}
variable "eks_aws_auth_users" {}
variable "eks_node_group_capacity_type" {}
variable "eks_node_group_instance_types" {}
variable "eks_node_group_disk_size" {}
variable "eks_node_group_desired_size" {}
variable "eks_node_group_max_size" {}
variable "eks_node_group_min_size" {}
variable "eks_node_group_additional_sg" {}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}


module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = var.eks_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.eks_cluster_endpoint_public_access_cidrs

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  vpc_id     = var.eks_vpc_id
  subnet_ids = var.eks_subnet_ids

  ## Extend cluster security group rules
  #cluster_security_group_additional_rules = {
  #  egress_nodes_ephemeral_ports_tcp = {
  #    description                = "To node 1025-65535"
  #    protocol                   = "tcp"
  #    from_port                  = 1025
  #    to_port                    = 65535
  #    type                       = "egress"
  #    source_node_security_group = true
  #  }
  #}
  #
  ## Extend node-to-node security group rules
  #node_security_group_additional_rules = {
  #  ingress_self_all = {
  #    description = "Node to node all ports/protocols"
  #    protocol    = "-1"
  #    from_port   = 0
  #    to_port     = 0
  #    type        = "ingress"
  #    self        = true
  #  }
  #  egress_all = {
  #    description      = "Node all egress"
  #    protocol         = "-1"
  #    from_port        = 0
  #    to_port          = 0
  #    type             = "egress"
  #    cidr_blocks      = ["0.0.0.0/0"]
  #    ipv6_cidr_blocks = ["::/0"]
  #  }
  #}

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = var.eks_node_group_disk_size
    instance_types = var.eks_node_group_instance_types

    attach_cluster_primary_security_group = true
    vpc_security_group_ids = [
      var.eks_node_group_additional_sg
    ]
  }

  eks_managed_node_groups = {
    #blue = {}
    green = {
      min_size     = var.eks_node_group_min_size
      max_size     = var.eks_node_group_max_size
      desired_size = var.eks_node_group_desired_size

      instance_types = var.eks_node_group_instance_types
      capacity_type  = var.eks_node_group_capacity_type
      labels = {
        Environment = var.env
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }

      #taints = {
      #  dedicated = {
      #    key    = "dedicated"
      #    value  = "gpuGroup"
      #    effect = "NO_SCHEDULE"
      #  }
      #}

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }

      tags = {
        Environment = var.env
      }
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = var.eks_manage_aws_auth_configmap
  aws_auth_roles            = var.eks_aws_auth_roles
  aws_auth_users            = var.eks_aws_auth_users

  tags = {
    Environment = var.env
  }
}

resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Environment = var.env
  }
}
