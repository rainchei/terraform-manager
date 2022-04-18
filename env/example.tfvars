# general
env             = "example"
s3_state_bucket = "example-tf-state"
region          = "ap-northeast-1"

# vpc
vpc_name = "example-vpc"

# eks
eks_cluster_name                   = "example-kube"
eks_cluster_version                = "1.22"
eks_cluster_endpoint_public_access = "true"
eks_cluster_endpoint_public_access_cidrs = [
  "0.0.0.0/0" # open to all traffic
]
eks_vpc_id = "vpc-xxx"
eks_subnet_ids = [
  "subnet-xxx", # private ap-northeast-1a
  "subnet-xxx"  # private ap-northeast-1c
]
eks_manage_aws_auth_configmap = "true"
eks_aws_auth_roles = [
  {
    rolearn  = "arn:aws:iam::777777777777:role/admin_role"
    username = "admin_role"
    groups   = ["system:masters"]
  }
]
eks_aws_auth_users = [
  {
    userarn  = "arn:aws:iam::777777777777:user/admin_user"
    username = "admin_user"
    groups   = ["system:masters"]
  }
]
eks_node_group_capacity_type = "SPOT" # ON_DEMAND or SPOT
eks_node_group_instance_types = [
  "t3.small",
]
eks_node_group_disk_size     = 20
eks_node_group_max_size      = 2
eks_node_group_min_size      = 1
eks_node_group_desired_size  = 2
eks_node_group_additional_sg = "sg-xxx" # default
