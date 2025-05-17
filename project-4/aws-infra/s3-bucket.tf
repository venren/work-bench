resource "aws_s3_bucket" "raw_financial_data_bucket" {
  bucket = "raw-venren-fin-data"  # Change this to your desired bucket name
  acl    = "private"            # Setting the access control to private

  versioning {
    enabled = true  # Enable versioning to track changes to files
  }
}

resource "aws_s3_bucket_object" "lambda_zip" {
  bucket = aws_s3_bucket.raw_financial_data_bucket.bucket
  key    = "lambda/file_upload_function.zip"  # Path in S3
  source = "file_upload_function.zip"         # Local path to ZIP
  etag   = filemd5("file_upload_function.zip") # Ensure updates
}