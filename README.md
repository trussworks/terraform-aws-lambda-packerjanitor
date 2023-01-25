# DEPRECIATION NOTICE
 
This module has been deprecated and is no longer maintained. Should you need to continue to use it, please fork the repository. Thank you.
 
 Creates a Lambda function with associated role and policies that
will run the packer-janitor tool to get rid of orphaned Packer
instances and their associated resources.

Creates the following resources:

* Lambda function
* IAM role and policies to describe and delete instances, keypairs,
  and security groups, as well as write messages to Cloudwatch Logs
* Cloudwatch Logs group
* Cloudwatch Event to regularly run cleanup job

## Terraform Versions

Terraform 0.13: Pin module version to ~> 2.X. Submit pull requests to master branch.

Terraform 0.12: Pin module version to ~> 1.X. Submit pull requests to terraform012 branch.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates a Lambda function with associated role and policies that
will run the packer-janitor tool to get rid of orphaned Packer
instances and their associated resources.

Creates the following resources:

* Lambda function
* IAM role and policies to describe and delete instances, keypairs,
  and security groups, as well as write messages to Cloudwatch Logs
* Cloudwatch Logs group
* Cloudwatch Event to regularly run cleanup job

## Usage

```hcl
module "packerjanitor-lambda" {
  source                 = "trussworks/lambda-packerjanitor/aws"
  packer_resource_delete = true
  packer_timelimit       = "2"
  job_identifier         = "sample_app"
  s3_bucket              = "sample_app_lambdas"
  version_to_deploy      = "2.8"
}
```

For more details on the capabilities of the packer-janitor tool, as
well as how to deploy it, see <https://github.com/trussworks/truss-aws-tools>.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| packerjanitor\_lambda | trussworks/lambda/aws | ~>1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_logs\_retention\_days | Number of days to retain Cloudwatch logs. Default is 90 days. | `string` | `90` | no |
| interval\_minutes | How often to run the packer janitor, in minutes. Default is 60 (1 hour). | `string` | `60` | no |
| job\_identifier | A generic job identifier to make resources for this job more obvious. | `string` | n/a | yes |
| packer\_resource\_delete | Perform the actual delete of abandoned Packer resources | `string` | n/a | yes |
| packer\_timelimit | Number of hours after which a Packer instance will be considered abandoned. Default is 4 hours. | `string` | `4` | no |
| s3\_bucket | The name of the bucket used to store the Lambda builds. | `string` | n/a | yes |
| version\_to\_deploy | The version of the Lambda function to deploy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | ARN for the packerjanitor lambda function |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
