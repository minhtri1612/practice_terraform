output "demo_bucket_name" {
  value = aws_s3_bucket.demo.id
}

output "demo_bucket_arn" {
  value = aws_s3_bucket.demo.arn
}
