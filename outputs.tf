output "lambda_arn" {
  description = "ARN for the packerjanitor lambda function"
  value       = module.packerjanitor_lambda.lambda_arn
}
