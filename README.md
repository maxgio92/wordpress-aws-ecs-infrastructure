# Wordpress application's containerized infrastructure management on AWS ECS

This project is based on Terraform.

## Project architecture

### Blocks

The project consists of infrastructure blocks made as independent as possible:

| Block | Configuration file | Variables file | 
| --- | --- | --- |
| Network | network.tf | network\_variables.tf |
| Container hosts cluster | cluster.tf | cluster\_variables.tf |
| Network filesystem for shared storage| nfs.tf | / |
| Application web service | application.tf | application\_variables.tf |
| Public load balancer | load\_balancer.tf | / |
| Database | database.tf | database\_variables.tf |
| Resources for HTTPS | https.tf | https\_variables.tf |
| Docker images repositories | repositories.tf | / |

### Terraform configuration:

| Part | Configuration file |
| --- | --- |
| Backend | terraform\_backend.tf |
| Providers | terraform\_providers.tf |

## Pre-run

### Creation of the needed resources for the Terraform backend

This step needs to be executed only on the project startup.

#### Requisites
- an IAM user on the **administrator account** that have permissions on:
 - S3 (create buckets and others listed in detail here: https://www.terraform.io/docs/backends/types/s3.html#s3-bucket-permissions) 
 - DynamoDB (create tables and others listed in detail here: https://www.terraform.io/docs/backends/types/s3.html#dynamodb-table-permissions)

NB: Remember to configure the credentials via environment variables with AWS\_PROFILE or AWS\_ACCESS\_KEY\_ID and AWS_SECRET\_ACCESS\_KEY before proceeeding.
Initialize on the administrator account the resources that the **Terraform backend** requires.

#### Creation

The needed resources will be configured through the init.sh script.

Requisites:

- Python virtualenv

Resources that will be created:

- an S3 bucket to store the Terraform state files
- a DynamoDB table for state locking and consistency checking

```
APP_NAME=wordpress-aws-ecs-infrastructure ./init.sh
```

### Backend initialization

The backend is based on an S3 bucket for state files storage and a DynamoDB table for state files locking.

Initialize the backend if has not yet been done:

```
terraform init
```

## Run

### Requisites

- an IAM user with AdministratorAccess policy

Please specify the user's credentials via environment variables* or edit the terraform\_providers.tf file.

The required input variables will be requested running terraform plan/apply. To avoid it create a .tfvars file and specify it with the '-var-file' option or create a .auto.tfvars file on the root of the project.

\* AWS\_ACCESS\_KEY\_ID + AWS\_SECRET\_ACCESS\_KEY or if configured, AWS\_PROFILE.

### Apply

Check the changes and apply them:

```
terraform apply
```

### Input variable

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_dns\_zone\_name | The DNS zone name of your application domain names | string | n/a | yes |
| app\_domain\_names | The domain names to associate to your application | list | n/a | yes |
| app\_endpoint\_public\_http\_port | The port on which to communicate via HTTP to the application | string | n/a | yes |
| app\_endpoint\_public\_https\_port | The port on which to communicate via HTTPS to the application | string | n/a | yes |
| app\_name | The name of the application | string | n/a | yes |
| app\_service\_desired\_capacity | The desired number of ECS tasks to place and keep running | string | `"4"` | no |
| app\_service\_max\_capacity | The maximum number of ECS tasks to place and keep running | string | `"8"` | no |
| app\_service\_min\_capacity | The minimum number of ECS tasks to place and keep running | string | `"2"` | no |
| app\_service\_nginx\_image\_version | The version of the NGiNX image | string | `"latest"` | no |
| app\_service\_nginx\_memory\_soft\_limit | The memory soft limit for the PHP-FPM container (MB) | string | `"128"` | no |
| app\_service\_php\_fpm\_image\_version | The version of the PHP-FPM image | string | `"latest"` | no |
| app\_service\_php\_fpm\_memory\_soft\_limit | The memory soft limit for the PHP-FPM container (MB) | string | `"256"` | no |
| aws\_region |  | string | `"eu-west-1"` | no |
| database\_cluster\_parameter\_group\_name |  | string | `"default.aurora-mysql5.7"` | no |
| database\_cluster\_parameter\_group\_parameters |  | list | `<list>` | no |
| database\_create\_cluster\_parameter\_group |  | string | `"false"` | no |
| database\_create\_instance\_parameter\_group |  | string | `"false"` | no |
| database\_engine |  | string | `"aurora-mysql"` | no |
| database\_engine\_version |  | string | `"5.7.12"` | no |
| database\_family |  | string | `"aurora-mysql5.7"` | no |
| database\_instance\_class |  | string | `"db.t2.small"` | no |
| database\_instance\_parameter\_group\_name |  | string | `"default.aurora-mysql5.7"` | no |
| database\_instance\_parameter\_group\_parameters |  | list | `<list>` | no |
| database\_modifications\_apply\_immediately |  | string | `"false"` | no |
| database\_name |  | string | `""` | no |
| database\_replica\_count |  | string | `"2"` | no |
| database\_username |  | string | `""` | no |
| ecs\_cluster\_instance\_key\_name | The key name to use for the ECS cluster's instances | string | `""` | no |
| ecs\_cluster\_instance\_types | A list of 2 instance types for the ECS cluster.   The list is prioritized: instances at the top of the list   will be used in preference to those lower down. | list | n/a | yes |
| ecs\_cluster\_mount\_efs | Whether to mount an EFS filesystem on ECS cluster' instances. | string | `"true"` | no |
| env\_name | The name of the application environment | string | n/a | yes |
| network\_cidr | The CIDR block of the network | string | n/a | yes |
| network\_private\_subnet\_count | How much private subnets to create | string | n/a | yes |
| network\_private\_subnet\_mask\_newbits | The number of bits of the private subnet mask to add   to the ones of the network's subnet mask.   E.g: network's CIDR block: 10.0.0.0/8 (8 bits subnet mask);   private subnet's CIDR block: 10.0.0.0/16 (16 bits    subnet mask, 8 new bits). | string | n/a | yes |
| network\_public\_subnet\_count | How much public subnets to create | string | n/a | yes |
| network\_public\_subnet\_mask\_newbits | The number of bits of the public subnet mask to add   to the ones of the network's subnet mask.   E.g: network's CIDR block: 10.0.0.0/8 (8 bits subnet mask);   public subnet's CIDR block: 10.0.0.0/16 (16 bits    subnet mask, 8 new bits). | string | n/a | yes |

