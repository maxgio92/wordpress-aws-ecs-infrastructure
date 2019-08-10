# Wordpress application's containerized infrastructure management on AWS ECS

This project is based on Terraform.

## Project architecture

### Terraform modules structure

### State management

#### Terraform backend

##### Creation of the needed resources *

###### Requisites
- an IAM user on the **administrator account** that have permissions on:
 - S3 (create buckets and others listed in detail here: https://www.terraform.io/docs/backends/types/s3.html#s3-bucket-permissions) 
 - DynamoDB (create tables and others listed in detail here: https://www.terraform.io/docs/backends/types/s3.html#dynamodb-table-permissions)

NB: Remember to configure the credentials via environment variables with AWS\_PROFILE or AWS\_ACCESS\_KEY\_ID and AWS_SECRET\_ACCESS\_KEY before proceeeding.
Initialize on the administrator account the resources that the **Terraform backend** requires.

###### Creation
This will create:

- an S3 bucket to store the Terraform state files
- a DynamoDB table for state locking and consistency checking

``
PROJECT_NAME=wordpress-aws-ecs-infrastructure ./init.sh
``

##### Backend initialization *

The backend is based on an S3 bucket for state files storage and a DynamoDB table for state files locking.

Initialize the backend if has not yet been done:

```
terraform init
```
**\*** to do only once and whenever a new module is added.
