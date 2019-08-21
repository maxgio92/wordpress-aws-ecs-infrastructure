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








