# general
env             = "my"
s3_state_bucket = "my-tf-state-cheilin"
region          = "ap-northeast-1"

# vpc
vpc_name = "my-vpc"

# eks
eks_cluster_name                   = "my-kube"
eks_cluster_version                = "1.22"
eks_cluster_endpoint_public_access = "true"
eks_cluster_endpoint_public_access_cidrs = [
  "0.0.0.0/0" # open to all traffic
]
eks_vpc_id = "vpc-0b94b76cad8fec2b8"
eks_subnet_ids = [
  "subnet-0de365132d8d89a25", # private ap-northeast-1a
  "subnet-0292b8311bbe5536a"  # private ap-northeast-1c
]
eks_manage_aws_auth_configmap = "true"
eks_aws_auth_roles = [
  {
    rolearn  = "arn:aws:iam::843169642313:role/Admin"
    username = "admin_role"
    groups   = ["system:masters"]
  }
]
eks_aws_auth_users = [
  {
    userarn  = "arn:aws:iam::843169642313:user/cheilin"
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
eks_node_group_additional_sg = "sg-00317764c24d8106b" # default
