resource "aws_ecr_repository" "my_ecr_repository" {
  name = "my-ecr-repo"
}
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = aws_ecs_cluster.my_cluster.name
  container_definitions    = jsonencode([{
    name                    = "my-container"
    image                   = "${aws_ecr_repository.my_ecr_repository.repository_url}:latest"
    essential               = true
    portMappings            = [{
      containerPort         = 8082
      hostPort              = 8082
      protocol              = "tcp"
    }]
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
}




resource "aws_ecs_service" "default" {
  name            = local.name
  cluster         = aws_ecs_cluster.my_cluster.name
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = module.vpc.public_subnets

    security_groups = [
      aws_security_group.ecs_task.id
    ]
    assign_public_ip = true # not ideal, but to help avoid paying for a NAT gateway
  }

  depends_on = [aws_lb.default]

  # java app can take ~100 seconds to start up with
  # current memory settings
  # 2023-03-05 17:44:11.314  INFO 7 --- [           main] example.App                              : Started App in 88.608 seconds (JVM running for 93.593)
  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.default.arn
    container_name   = "my-container"
    container_port   = 8082
  }
}
resource "aws_security_group" "ecs_task" {
  name   = "${local.name}-ecs-task"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_task_ingress_alb" {
  security_group_id = aws_security_group.ecs_task.id

  type      = "ingress"
  from_port = 80
  protocol  = "tcp"
  to_port   = 80

  source_security_group_id = aws_security_group.alb.id

  description = "allows ALB to make requests to ECS Task"
}

resource "aws_security_group_rule" "ecs_task_egress_all" {
  security_group_id = aws_security_group.ecs_task.id

  type = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"

  cidr_blocks = ["0.0.0.0/0"]
  description = "allows ECS task to make egress calls"
}


