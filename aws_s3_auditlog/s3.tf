resource "aws_s3_bucket" "demo-test-bucket" {
  bucket = "${var.test_bucket}"  
  provider = aws.primary
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.aws-demo-test-kms.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  lifecycle_rule {
    id = "demo-test-lifecycle"
    expiration {
      days = 30
    }
    prefix = ""
    enabled = true
  }
}
#resource "aws_s3_bucket_acl" "demo-test-bucket" {
#  bucket = aws_s3_bucket.demo-test-bucket.id
#  acl    = "private"
#}
resource "aws_s3_bucket_public_access_block" "demo-test-auditlog-acl" {
  bucket = aws_s3_bucket.demo-test-bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
