resource "random_id" "bucket_suffix" {
  byte_length = 6
}

resource "aws_s3_bucket" "remote_backend" {
    bucket = "${var.backend_config["bucket"]}-${random_id.bucket_suffix.hex}"

    lifecycle {
        prevent_destroy = true
    }
  
}

output "bucket_name" {
  value = aws_s3_bucket.remote_backend.bucket
  
}