# Security Group para el acceso público
resource "aws_security_group" "sg_publico" {
  name        = "${var.project_name}-public-sg"
  description = "Permitir SSH seguro"
  vpc_id      = aws_vpc.main.id
  ingress {
    description      = "SSH desde IPs seguras"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "Permitir todo el trafico de salida"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Public-SG"
    }
}   

# Security Group para el acceso privado
resource "aws_security_group" "sg_privado" {
    name        = "${var.project_name}-private-sg"
    description = "Permitir trafico interno y actualizaciones"
    vpc_id      = aws_vpc.main.id
    ingress {
        #description      = "Permitir trafico desde el SG publico"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups  = [aws_security_group.sg_publico.id]
    }
    egress {
        description      = "Permitir todo el trafico de salida"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Private-SG"
    }
}
