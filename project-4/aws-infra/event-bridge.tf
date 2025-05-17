resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name        = "lambda_trigger_rule"
  description = "Rule to trigger Lambda function at specific time"
  schedule_expression = "cron(0 10 * * ? *)"  # This cron expression triggers the Lambda at 10:00 AM UTC every day

  # You can modify the schedule expression as needed for your specific time
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.eventbridge_rule.name
  arn  = aws_lambda_function.file_upload_lambda.arn

  # Allow EventBridge to invoke the Lambda function
  role_arn = aws_iam_role.lambda_exec_role.arn
}

resource "aws_iam_role" "eventbridge_invocation_role" {
  name = "eventbridge_invocation_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_lambda_permission" {
  role       = aws_iam_role.eventbridge_invocation_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eventbridge_rule.arn
}
