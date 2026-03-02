# Imagen Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

# Instancia en la Bíveda Privada
resource "aws_instance" "servidor_app" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.privada_1.id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.sg_privado.id]

  #Instalación de Apache y configuración del sitio web
  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install -y httpd
            systemctl start httpd
            systemctl enable httpd
            echo "<h1>Proyecto de Infraestructura Segura - Fernando 2026</h1>" > /var/www/html/index.html
            EOF

  tags = {
    Name = "${var.project_name}-app-server"
  }
}
