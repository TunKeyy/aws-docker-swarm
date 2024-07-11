# resource "aws_instance" "instance1" {
#   count = var.instance_count
#   ami = "ami-060e277c0d4cce553"
#   instance_type = "t2.micro"
#   key_name = var.key_name
#   security_groups = [
#     var.sec_group_name,
#   ]
#   vpc_security_group_ids = [ 
#     aws_security_group.instance.id,
#    ]
#    root_block_device {
#      volume_size = var.volume_size
#    }
# }

# resource "aws_security_group" "instance" {
#   description = var.sec_group_description
#   egress = [
#     {
#       cidr_blocks = [
#         "0.0.0.0/0"
#       ]
#       description = ""
#       from_port = 0
#       ipv6_cidr_blocks = []
#       prefix_list_ids = []
#       protocol = "-1"
#       security_groups = []
#       self = false
#       to_port = 0
#     }
#   ]
#   ingress = [ 
#     for _port in var.port_list:
#     {
#       cidr_blocks = [
#         for _ip in var.ip_list:
#         _ip
#       ]
#       description = ""
#       from_port = _port
#       ipv6_cidr_blocks = []
#       prefix_list_ids = []
#       protocol = "tcp"
#       security_groups = []
#       self = false
#       to_port = _port
#     }
#    ]
#    name = var.sec_group_name
# }


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
  key_name = "test-docker-swarm-1"

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
