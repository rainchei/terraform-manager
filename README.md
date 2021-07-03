# terraform-manager

Provide a place to manage Terraform configs easily.

## Prereqs

* [Terraform CLI](https://www.terraform.io/docs/cli/index.html): Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html): It is a must have since almost all our infrastructures are running on AWS.
* [S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html): A pre-created AWS S3 bucket to store and share the state for provisioned resources.
* [Permissions](https://aws.amazon.com/iam/features/manage-permissions/): Depends on the module, required permissions must be allowed for the user to run. For example, [eks-iam-permissions].

## Env

Place to assign values for variables that defined within a module. They may be distinct from each other depending on its running environment.

## Getting Started

If you are familiar with Terraform, it should be straightforward to run on this project. 
We have provided a [deploy.sh] for you, so you don't have to `cd` to each module. All you need to do is ensuring
- Env: example (i.e. [env/example.tfvars]) ...
- Module: eks (i.e. [eks]), vpc, or rds ...

## Usage Example

Initialize the working directory
```
./deploy.sh init env/example.tfvars eks
```

Create an execution plan
```
./deploy.sh plan env/example.tfvars eks
```

Apply the changes required to reach the desired state of the configuration
```
./deploy.sh apply env/example.tfvars eks
```

Destroy the infrastructure defined within the configuration
```
./deploy.sh destroy env/example.tfvars eks
```

## Modules

A Terraform module is a set of Terraform configuration files in a single directory. In this project, though we're using the same term "module".
It merely means a working directory that encapsulates one or many terraform modules, like [eks].
It is suggested to use module with official support like [terraform-aws-eks], as to keep up with the latest updates from AWS.


### EKS - RBAC Authorization

Deploy "default-admin" `Role` with permissions on "default" `Namespace`
```
cat <<EOF | kubectl apply -f -
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: default-admin
  namespace: default
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - '*'
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-admin
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: default-admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: default-admin
EOF
```

<!-- MARKDOWN LINKS & IMAGES -->
[Terraform CLI]: https://www.terraform.io/docs/cli/index.html
[AWS CLI]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
[S3 Bucket]: https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html
[Permissions]: https://aws.amazon.com/iam/features/manage-permissions
[eks-iam-permissions]: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
[terraform-aws-eks]: https://github.com/terraform-aws-modules/terraform-aws-eks
[eks]: eks
[deploy.sh]: deploy.sh
[env/example.tfvars]: env/exapmle.tfvars
