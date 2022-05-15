# ENI
resource "aws_network_interface" "web_01" {
  subnet_id       = aws_subnet.public_subnet_1a.id
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "${var.prefix}-web-01"
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2
resource "aws_instance" "web_01" {
  instance_type           = "t2.micro"
  key_name                = "techbook-key"
  ami           = data.aws_ami.latest_amazon_linux.id

  network_interface {
    network_interface_id = aws_network_interface.web_01.id
    device_index = 0
  }

  tags = {
    Name = "${var.prefix}-web-01"
  }

  volume_tags = {
    Name = "${var.prefix}-web-01"
  }
}

output "web01_public_ip" {
  description = "The public IP address assigned to the instanceue"
  value       = aws_instance.web_01.public_ip
}

resource "aws_eip" "eip_web01" {
    instance = "${aws_instance.web_01.id}"
    vpc = true
}
