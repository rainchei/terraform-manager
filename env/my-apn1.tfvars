# general
env             = "my"
s3_state_bucket = "my-tf-state-cheilin"
region          = "ap-northeast-1"

# vpc
vpc_name = "my-vpc"

# # eks
# eks_cluster_name    = "my-kube-rainchei"
# eks_cluster_version = "1.23"
# eks_vpc_id          = "vpc-xxx"
# eks_subnets = [
#   "subnet-xxx", # private us-west-2a
#   "subnet-xxx"  # private us-west-2b
# ]
# eks_api_public_access = [
#   "x.x.x.x/32", # nat - private us-west-2a
#   "x.x.x.x/32", # nat - private us-west-2b
# ]
# eks_manage_aws_auth = "true"
# eks_map_roles = [
#   {
#     rolearn  = "arn:aws:iam::xxx:role/eks_admin"
#     username = "eks_admin"
#     groups   = ["system:masters"]
#   },
#   {
#     rolearn  = "arn:aws:iam::xxx:role/eks_default_admin"
#     username = "default-admin"
#     groups   = ["default-admin"]
#   }
# ]
# eks_node_group_capacity_type = "SPOT" # ON_DEMAND or SPOT
# eks_node_group_instance_types = [
#   "m5.xlarge",
#   "m5a.xlarge",
#   "m5ad.xlarge",
#   "m5d.xlarge",
#   "m4.xlarge",
#   "t3a.xlarge",
#   "t3.xlarge",
#   "t2.xlarge",
#   "r5.xlarge",
#   "r4.xlarge",
#   "r3.xlarge"
# ]
# eks_node_group_asg_max       = 8
# eks_node_group_asg_min       = 1
# eks_node_group_asg_desire    = 4
# eks_node_group_additional_sg = "sg-xxx" # default
