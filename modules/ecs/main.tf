resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.capacity}-cluster"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = data.aws_vpc.target_vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.aws_security_group.sg_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "ecs_service_task" {
  family                   = "${var.capacity}-service-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "${var.capacity}-service"
      image     = "${var.ecr_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "DB_USERNAME"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_HOST"
          value = var.rds_endpoint
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "SCHEMA"
          value = "public"
        }
      ]
    }
  ])
  execution_role_arn = var.task_execution_role_arn

  depends_on = [
    aws_ecs_cluster.ecs_cluster
  ]
}

resource "aws_ecs_service" "ecs_service_ms" {
  name            = "${var.capacity}-service-ms"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_service_task.arn
  desired_count   = 1
  force_new_deployment = true
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true 
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.capacity}-service"
    container_port   = 8080
  }

  depends_on = [
    aws_ecs_task_definition.ecs_service_task
  ]
}