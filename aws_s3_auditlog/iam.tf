
#test push log IAM
resource "aws_iam_access_key" "demo-test-log" {
  user    = aws_iam_user.demo-test-log.name
  #Encrypt key with pgp
  pgp_key = "keybase:${var.gpg_keybaseuser}"
}

resource "aws_iam_user" "demo-test-log" {
  name = "demo-testauditlog"
  path = "/"
}

data "aws_iam_policy_document" "demo-test-policy" {
  statement {
    actions   = ["s3:ListBucket","s3:GetBucketLocation"]
    resources = [aws_s3_bucket.demo-test-bucket.arn]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:PutObject" ,"s3:GetObject" ,"s3:DeleteObject"]
    resources = ["${aws_s3_bucket.demo-test-bucket.arn}/*"]
    effect = "Allow"
  }
  statement {
    actions   = ["kms:GenerateDataKey"]
    resources = [aws_kms_key.aws-demo-test-kms.arn]
    effect = "Allow"
  }
}
resource "aws_iam_policy" "test-policy" {
  name        = "${var.test_bucket}-policy"
  description = "${var.test_bucket} policy"
  policy = data.aws_iam_policy_document.demo-test-policy.json
}

resource "aws_iam_user_policy_attachment" "test-attachment" {
  user       = aws_iam_user.demo-test-log.name
  policy_arn = aws_iam_policy.test-policy.arn
}

#only print if -var="print_logaccount=true"
output "test_account" {
  value = var.print_logaccount ? "ID: ${aws_iam_access_key.demo-test-log.id} Encrypted_secret: ${aws_iam_access_key.demo-test-log.encrypted_secret}" : null
}

#siem pull log user
resource "aws_iam_access_key" "demo-siem-log" {
  user    = aws_iam_user.demo-siem-log.name
  #Encrypt key with pgp
  pgp_key = "keybase:${var.gpg_keybaseuser}"
}

resource "aws_iam_user" "demo-siem-log" {
  name = "demo-siemauditlog"
  path = "/"
}

data "aws_iam_policy_document" "demo-siem-policy" {
  statement {
    actions   = ["s3:ListBucket","s3:GetBucketLocation"]
    resources = [aws_s3_bucket.demo-test-bucket.arn]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:GetObject" ]
    resources = ["${aws_s3_bucket.demo-test-bucket.arn}/*"]
    effect = "Allow"
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.aws-demo-test-kms.arn]
    effect = "Allow"
  }
}
resource "aws_iam_policy" "siem-policy" {
  name        = "${var.test_bucket}-siem-policy"
  description = "${var.test_bucket} siem policy"
  policy = data.aws_iam_policy_document.demo-siem-policy.json
}

resource "aws_iam_user_policy_attachment" "siem-attachment" {
  user       = aws_iam_user.demo-siem-log.name
  policy_arn = aws_iam_policy.siem-policy.arn
}

#only print if -var="print_logaccount=true"
output "siem_account" {
  value = var.print_logaccount ? "ID: ${aws_iam_access_key.demo-siem-log.id} Encrypted_secret: ${aws_iam_access_key.demo-siem-log.encrypted_secret}" : null
}
