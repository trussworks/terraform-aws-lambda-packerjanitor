/**
 * Creates a Lambda function with associated role and policies that
 * will run the packer-janitor tool to get rid of orphaned Packer
 * instances and their associated resources.
 *
 * Creates the following resources:
 *
 * * Lambda function
 * * IAM role and policies to describe and delete instances, keypairs,
 *   and security groups, as well as write messages to Cloudwatch Logs
 * * Cloudwatch Logs group
 * * Cloudwatch Event to regularly run cleanup job
 *
 * ## Usage
 *
 * ```hcl
 * module "packer-janitor-lambda" {
 *   source                 = "trussworks/lambda-packerjanitor/aws"
 *   packer_resource_delete = "true"
 *   packer_timelimit       = "4"
 *   job_identifier         = "sample_app"
 *   s3_bucket              = "sample_app_lambdas"
 *   version_to_deploy      = "2.8"
 * }
 * ```
 *
 * For more details on the capabilities of the packer-janitor tool, as
 * well as how to deploy it, see <https://github.com/trussworks/truss-aws-tools>.
 */

locals {
  pkg  = "truss-aws-tools"
  name = "packer-janitor"
}

data "aws_region" "current" {}

# This is the main policy this job is going to need.
data "aws_iam_policy_document" "main" {
  # Allow describing instances, keypairs, and security groups.
  statement {
    sid    = "Describes"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
    ]

    resources = ["*"]
  }

  # Allow terminating EC2 Instances
  statement {
    sid    = "TerminateInstances"
    effect = "Allow"

    actions = [
      "ec2:TerminateInstances",
    ]

    resources = ["*"]
  }

  # Allow deleting key pairs.
  statement {
    sid    = "DeleteKeyPair"
    effect = "Allow"

    actions = [
      "ec2:DeleteKeyPair",
    ]

    resources = ["*"]
  }

  # Allow deleting security groups.
  statement {
    sid    = "DeleteSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:DeleteSecurityGroup",
    ]

    resources = ["*"]
  }
}

# Create the policy for the document we just added above.
resource "aws_iam_policy" "main" {
  name   = "${local.name}-${var.job_identifier}-policy"
  policy = "${data.aws_iam_policy_document.main.json}"
}

# Lambda function
module "packerjanitor_lambda" {
  source  = "trussworks/lambda/aws"
  version = "~>1.0.1"

  name                           = "${local.name}"
  job_identifier                 = "${var.job_identifier}"
  runtime                        = "go1.x"
  role_policy_arns_count         = 1
  role_policy_arns               = ["${aws_iam_policy.main.arn}"]
  cloudwatch_logs_retention_days = "${var.cloudwatch_logs_retention_days}"

  s3_bucket = "${var.s3_bucket}"
  s3_key    = "${local.pkg}/${var.version_to_deploy}/${local.pkg}.zip"

  source_types = ["events"]
  source_arns  = ["${aws_cloudwatch_event_rule.main.arn}"]

  env_vars {
    DELETE    = "${var.packer_resource_delete}"
    TIMELIMIT = "${var.packer_timelimit}"

    # This will run the Packer janitor with its Lambda handler.
    LAMBDA = true
  }

  tags {
    Name = "${local.name}-${var.job_identifier}"
  }
}

# Cloudwatch event for regular running of the Lambda function.
resource "aws_cloudwatch_event_rule" "main" {
  name                = "${local.name}-${var.job_identifier}"
  description         = "scheduled trigger for ${local.name}"
  schedule_expression = "rate(${var.interval_minutes} minutes)"
}

resource "aws_cloudwatch_event_target" "main" {
  rule = "${aws_cloudwatch_event_rule.main.name}"
  arn  = "${module.packerjanitor_lambda.lambda_arn}"
}
