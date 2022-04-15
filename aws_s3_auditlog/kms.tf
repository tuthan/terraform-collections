resource "aws_kms_key" "aws-demo-test-kms" {
  description = "aws-demo-test-kms"
  multi_region = "true"
  deletion_window_in_days = 30
  provider = aws.primary

  tags = {
    Name                 = "aws-demo-test-kms"
  }

}

resource "aws_kms_alias" "aws-demo-test-kms" {
  name          = "alias/aws-demo-test-kms"
  provider      = aws.primary
  target_key_id = aws_kms_key.aws-demo-test-kms.key_id
}