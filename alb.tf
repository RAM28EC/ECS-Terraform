resource "aws_instance" "intro" {
  ami = var.AMIS
  instance_type = "t3.micro"
  associate_public_ip_address = true
  subnet_id = module.vpc.public_subnets[0]
  availability_zone = var.ZONE1
  key_name = "task-key"
  vpc_security_group_ids = [ aws_security_group.alb.id ]
  tags = {
    Name = "Intro-instance"
  }
}
resource "aws_lb_target_group" "default" {
  name        = "alb-target"
  port        = 8082
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "10"
    unhealthy_threshold = "2"
  }
  deregistration_delay = 300
}
  


resource "aws_lb" "default" {
  name            = "task-alb"
  subnets            = module.vpc.public_subnets
  load_balancer_type = "application"
  security_groups =   [ aws_security_group.alb.id ]
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.default.id
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  description = "controls access to the application ELB"

  vpc_id = module.vpc.vpc_id
  name   = "${local.name}-alb"

 ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  } 
  

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}