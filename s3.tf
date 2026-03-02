#Crear bucket S3
resource "aws_s3_bucket" "bucket_seguro"{
    bucket = "${var.project_name}-data-storage-${random_id.suffix.hex}"
    
    tags = {
        Name = "${var.project_name}-s3"
        environment = "Dev"}
}

# Habilitar el cifrado automático (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
    bucket = aws_s3_bucket.bucket_seguro.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Bloqueo total de acceso público
resource "aws_s3_bucket_public_access_block" "s3_block" {
    bucket = aws_s3_bucket.bucket_seguro.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# Generar un sufijo aleatorio para el nombre del bucket
resource "random_id" "suffix" {
    byte_length = 4
}