# 1. Fetch the latest free-tier eligible Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# 2. Create a Security Group (Firewall) to allow web traffic
resource "aws_security_group" "web_sg" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
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

# 3. Provision the EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro" # Free Tier eligible
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Simple script to start an Apache web server on boot
  user_data = <<-EOF
              #!/bin/bash
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform on AWS!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "My-Broken-Server"
  }
}

# 4. Output the public URL to test your server
output "website_url" {
  value       = "http://${aws_instance.web_server.public_ip}"
  description = "Click this URL to visit your web server"
}
