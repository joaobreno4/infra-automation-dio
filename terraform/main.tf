terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Nossa Rede (VPC e Internet Gateway)
resource "aws_vpc" "minha_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "VPC-DIO-Terraform" }
}

resource "aws_internet_gateway" "meu_igw" {
  vpc_id = aws_vpc.minha_vpc.id
  tags = { Name = "IGW-DIO" }
}

# 2. Roteamento e Subnet
resource "aws_route_table" "tabela_rotas" {
  vpc_id = aws_vpc.minha_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.meu_igw.id
  }
  tags = { Name = "Tabela-Rotas-DIO" }
}

resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.minha_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "Subnet-Publica-DIO" }
}

resource "aws_route_table_association" "associacao" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.tabela_rotas.id
}

# 3. Firewall (Security Group)
resource "aws_security_group" "meu_sg" {
  name        = "Permite_SSH_HTTP_DIO"
  description = "Regras de entrada e saida"
  vpc_id      = aws_vpc.minha_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permite tudo pra fora
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Buscando a imagem do Linux mais atualizada
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 5. O Servidor EC2 com Bootstrap
resource "aws_instance" "servidor_web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_publica.id
  vpc_security_group_ids = [aws_security_group.meu_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Projeto DIO.me - Infra automatizada com Terraform!</h1><p>Autor: Joao Breno</p>" > /var/www/html/index.html
              EOF

  tags = { Name = "Servidor-DIO-Terraform" }
}

# 6. O que queremos ver no final
output "ip_publico" {
  value       = aws_instance.servidor_web.public_ip
  description = "Acesse este IP no navegador"
}
