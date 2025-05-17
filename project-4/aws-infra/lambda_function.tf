resource "aws_lambda_function" "file_upload_lambda" {
  function_name = "file_upload_lambda"
  s3_bucket     = aws_s3_bucket.raw_financial_data_bucket.bucket
  s3_key        = aws_s3_bucket_object.lambda_zip.key
  handler       = "download_file.uploadRawDataTos3"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.raw_financial_data_bucket.bucket
    }
  }
}


resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.raw_financial_data_bucket.bucket}/*"  # Reference the bucket ARN here
      }
    ]
  })
}

