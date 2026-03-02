# 1. Rol de IAM
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Perfil de instancia (el "Gafete")
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# 3. Política de Mínimo Privilegio 
resource "aws_iam_role_policy" "s3_access_policy" {
    name = "S3AccessPolicy"
    role = aws_iam_role.ec2_role.id

    policy = jsonencode({
        Version = "2012-10-17" 
        Statement = [          
            {
                Action = [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:ListBucket"
                ]
                Effect = "Allow"
                Resource = [
                    "${aws_s3_bucket.bucket_seguro.arn}",
                    "${aws_s3_bucket.bucket_seguro.arn}/*"
                ]
            }
        ]
    })
}