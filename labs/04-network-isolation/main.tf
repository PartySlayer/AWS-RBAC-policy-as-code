
module "vpc" {
  source = "../../modules/vpc"

  nome_progetto = var.project_name

  # Definiamo solo una subnet pubblica per semplicità
  public_subnet_cidrs = ["10.0.1.0/24"]
  
  private_app_subnet_cidrs = [] # non ci servono per il lab 
  private_data_subnet_cidrs = [] # non ci servono per il lab 
}

# VPC ENDPOINT: è il tunnel tra s3 e la rete
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.eu-south-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [module.vpc.public_route_table_id]

  tags = { Name = "${var.project_name}-vpc-endpoint" }
}

# Bucket
module "s3_bucket" {
  source = "../../modules/s3"
  bucket_prefix = "network-iso-lab"
}

# Policy realistica, super stringente
resource "aws_s3_bucket_policy" "network_restriction" {
  bucket = module.s3_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyAccessFromOutsideVPC"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          module.s3_bucket.bucket_arn,
          "${module.s3_bucket.bucket_arn}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:SourceVpce" = aws_vpc_endpoint.s3.id
          }
        }
      }
    ]
  })
}

# EC2 per il test
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy" "s3_access" {
  name = "S3FullAccess"
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "s3:*", Effect = "Allow", Resource = "*" }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.ec2_role.name
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  vpc_id = module.vpc.vpc_id
  name   = "allow_ssh"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "tester" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  
  # Il modulo restituisce una LISTA di ID, attenzione! Ne prendiamo il primo

  subnet_id     = module.vpc.public_subnet_ids[0]
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = { Name = "${var.project_name}-vm" }
}