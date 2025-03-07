resource "aws_vpc" "default_vpc" {  # default vpc
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "default_subnet" {
  vpc_id = aws_vpc.default_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "default_subnet"
  }
}

resource "aws_internet_gateway" "default_gateway" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "default_gateway"
  }
}

resource "aws_route_table" "default_route" {
  vpc_id = aws_vpc.default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default_gateway.id
  }

  tags = {
    Name = "default_route"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id = aws_subnet.default_subnet.id
  route_table_id = aws_route_table.default_route.id
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.default_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2377
    to_port = 2377
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 139
    to_port = 139
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 445
    to_port = 445
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_sg"
  }
}

resource "aws_instance" "swarm_nodes" {
  count = 2
  ami = "ami-060e277c0d4cce553"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.default_subnet.id
  security_groups = [aws_security_group.instance.id]
  associate_public_ip_address = true
  key_name = "docker-swarm-ubuntu"

  tags = {
    Name = "swarm-node-${count.index + 1}"
  }
  
  depends_on = [ aws_security_group.instance ]

  # provisioner "remote-exec" {
  #   inline = [ 
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker.io",
  #     "sudo systemctl start docker",
  #     "sudo systemctl enable docker"
  #   ]

  #   connection {
  #     type = "ssh"
  #     user = "ubuntu"
  #     private_key = file("docker-swarm-ubuntu.pem")
  #     host = self.public_ip
  #   } 
  # }
}
