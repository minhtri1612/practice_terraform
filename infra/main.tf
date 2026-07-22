# Sample resource để practice plan/apply qua CI — đổi thoải mái.

resource "aws_s3_bucket" "demo" {
  bucket_prefix = "${var.project_name}-${var.environment}-"

  tags = {
    Name        = "${var.project_name}-${var.environment}-demo"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

