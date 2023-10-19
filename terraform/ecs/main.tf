# CloudWatch log group for ECS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/aws/ecs/${var.prefix}log-group"
  retention_in_days = 90
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.prefix}ecs-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                = "${var.prefix}ecs-task-definition"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = var.execution_role_arn
  task_role_arn         = var.execution_role_arn
  
  container_definitions = jsonencode(
      jsondecode(templatefile("${path.module}/ecs_task_definition.json", {
      prefix    = var.prefix,
      image_url = var.image_url
    }))["containerDefinitions"]
  )
}

# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "${var.prefix}ecs-sg"
  description = "ECS Security Group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ecs_sg_from_alb" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  security_group_id = aws_security_group.ecs_sg.id
  source_security_group_id = var.alb_security_group_id
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "${var.prefix}ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type     = "FARGATE"
#   desired_count   = length(var.private_subnets)
  desired_count   = 1

  network_configuration {
    subnets = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.prefix}container"
    container_port   = 5001
  }
}
