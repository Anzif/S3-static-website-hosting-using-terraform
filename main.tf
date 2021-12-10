resource "aws_s3_bucket" "static" {
  bucket = var.domain_name
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
               aws_s3_bucket.static.arn,
               "${aws_s3_bucket.static.arn}/*",
            ]
        }
    ]
  })
}


resource "aws_s3_bucket_object" "webfiles" {
  for_each      = fileset("myfiles/", "**/*.*")
  bucket        = aws_s3_bucket.static.id
  key           = replace(each.value, "myfiles/", "")
  source        = "myfiles/${each.value}"
  acl           = "public-read"
  etag          = filemd5("myfiles/${each.value}")
  content_type  = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}


output "fileset-results" {
  value = fileset(path.module, "**/*.*")
}


output "url" {
    value = aws_s3_bucket.static.website_endpoint
}
