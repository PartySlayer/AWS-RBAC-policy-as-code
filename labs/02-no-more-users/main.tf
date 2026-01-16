module "s3_bucket" {
  source = "../../modules/s3"

  bucket_prefix = "ec2-role-lab"
  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name = "${var.project_name}-role"

  # Trust Policy: Chi può assumere questo ruolo? "ec2.amazonaws.com" ovvero il servizio EC2
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

# Cosa può fare chi assume questo ruolo? Leggere il bucket.
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "S3ReadAccess"
  role = aws_iam_role.ec2_s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          module.s3_bucket.bucket_arn,       # Il bucket creato dal modulo
          "${module.s3_bucket.bucket_arn}/*" # Gli oggetti dentro
        ]
      }
    ]
  })
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  # Assegnamo il profilo (quindi il ruolo) alla vm

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "${var.project_name}-vm"
  }
}