variable "cloudwatch_logs_retention_days" {
  default     = 90
  description = "Number of days to retain Cloudwatch logs. Default is 90 days."
  type        = "string"
}

variable "interval_minutes" {
  default     = 60
  description = "How often to run the packer janitor, in minutes. Default is 60 (1 hour)."
  type        = "string"
}

variable "job_identifier" {
  description = "A generic job identifier to make resources for this job more obvious."
  type        = "string"
}

variable "packer_resource_delete" {
  description = "Perform the actual delete of abandoned Packer resources"
  type        = "string"
}

variable "packer_timelimit" {
  default     = 4
  description = "Number of hours after which a Packer instance will be considered abandoned. Default is 4 hours."
  type        = "string"
}

variable "s3_bucket" {
  description = "The name of the bucket used to store the Lambda builds."
  type        = "string"
}

variable "version_to_deploy" {
  description = "The version of the Lambda function to deploy."
  type        = "string"
}
