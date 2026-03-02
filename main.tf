#VPC Principal
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subredes Públicas (Balanceador y Bastion)
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a" # Zona A
  map_public_ip_on_launch = true
    tags = {
        Name = "Public-Subnet-A"
    }
}

# Subredes Privadas
resource "aws_subnet" "privada_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}a" # Zona A
    tags = {
        Name = "Private-Subnet-A"
    }
}

# Puerta a Internet
resource "aws_internet_gateway" "igw" { 
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Tabla de Rutas para Subredes Públicas
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public-rt"
  }
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Asociación de Subred Pública con la Tabla de Rutas
resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

# IP fija para el NAT Gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        Name = "${var.project_name}-nat-eip"
    }
}

# NAT Gateway en la Subred Pública
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_1.id
    tags = {
        Name = "${var.project_name}-nat-gw"
    }
    depends_on = [ aws_internet_gateway.igw ]
}

# Tabla de Rutas Privada
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        Name = "${var.project_name}-private-rt"
    }
}

# Asociación de Subred Privada con la Tabla de Rutas
resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.privada_1.id
  route_table_id = aws_route_table.private_rt.id
}
