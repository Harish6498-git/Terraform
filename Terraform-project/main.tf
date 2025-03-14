resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block_value
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.rT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.rT.id
}


resource "aws_security_group" "mysg" {
  name        = "web-sg"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_HTTP" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ingress_SSH" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_s3_bucket" "example" {
  bucket = "terraform-project-0604"
}

resource "aws_instance" "webserver1" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.sub1.id
  user_data = file("userdata.sh")
}

resource "aws_instance" "webserver2" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.sub2.id
  user_data = file("userdata1.sh")
}

#create alb [application load-balancer]
resource "aws_lb" "myalb" {
  name = "myalb"
  internal = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.mysg.id]
  subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

resource "aws_lb_target_group" "tg" {
  name = "tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webserver1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webserver2.id
  port = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}