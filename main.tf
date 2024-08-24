provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Custom Custom VPC"
  }
}

resource "aws_subnet" "custom_public_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.network_cidr_a
  availability_zone = var.zone_a
  map_public_ip_on_launch = true

  tags = {
    Name = "My Public Subnet"
  }
}

resource "aws_subnet" "custom_private_subnet" {


  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.network_cidr_b
  availability_zone = var.zone_b
  map_public_ip_on_launch = true

  tags = {
    Name = "Custom Private Subnet"
  }
}

resource "aws_internet_gateway" "custom_ig" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Custom Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.custom_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "sq_sg" {
  name   = "HTTP, SSH  and port 9000"
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_gmd_instance" {
  ami           = "ami-027575f554fa61ccc"
  instance_type = "t3.medium"
  key_name      = "DevOps"
  count = 1

  subnet_id                   = aws_subnet.custom_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data     =  "${file("/configs/jenkins_gmd.sh")}"

  

  tags = {
    "Name" : "Jenkins_GMD_Instance"
  }
}



resource "aws_instance" "ansible_instance" {
  ami           = "ami-027575f554fa61ccc"
  instance_type = "t3.micro"
  key_name      = "DevOps"
  count = 1

  subnet_id                   = aws_subnet.custom_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  # user_data     =  "${file("/configs/ansible_docker.sh")}"

  

  tags = {
    "Name" : "Ansible_Instance"
  }
}

resource "aws_instance" "kubernetes_instance" {
  ami           = "ami-027575f554fa61ccc"
  instance_type = "t3.micro"
  key_name      = "DevOps"
  count = 1

  subnet_id                   = aws_subnet.custom_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  # user_data     =  "${file("/configs/kubernetes_docker.sh")}"

  

  tags = {
    "Name" : "Kubernetes_Instance"
  }
}



