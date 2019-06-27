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
module "packer-janitor-lambda" {
  source                 = "trussworks/lambda-packerjanitor/aws"
  packer_resource_delete = "true"
  packer_timelimit       = "4"
  job_identifier         = "sample_app"
  s3_bucket              = "sample_app_lambdas"
  version_to_deploy      = "2.8"
}
```

For more details on the capabilities of the packer-janitor tool, as
well as how to deploy it, see <https://github.com/trussworks/truss-aws-tools>.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudwatch\_logs\_retention\_days | Number of days to retain Cloudwatch logs. Default is 90 days. | string | `"90"` | no |
| interval\_minutes | How often to run the packer janitor, in minutes. Default is 60 (1 hour). | string | `"60"` | no |
| job\_identifier | A generic job identifier to make resources for this job more obvious. | string | n/a | yes |
| packer\_resource\_delete | Perform the actual delete of abandoned Packer resources | string | n/a | yes |
| packer\_timelimit | Number of hours after which a Packer instance will be considered abandoned. Default is 4 hours. | string | `"4"` | no |
| s3\_bucket | The name of the bucket used to store the Lambda builds. | string | n/a | yes |
| version\_to\_deploy | The version of the Lambda function to deploy. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | ARN for the packerjanitor lambda function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
