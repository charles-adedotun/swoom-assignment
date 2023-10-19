# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# # S3 bucket for ALB logs
# resource "aws_s3_bucket" "alb_logs" {
#   bucket = "${var.prefix}alb-logs"
# }

# # Bucket policy to allow ALB to write logs
# resource "aws_s3_bucket_policy" "alb_log_policy" {
#   bucket = aws_s3_bucket.alb_logs.bucket

#   policy = templatefile("${path.module}/s3_bucket_policy.json", {
#     bucket_name = aws_s3_bucket.alb_logs.bucket,
#     alb_name    = "${var.prefix}alb"
#   })
# }

# ALB
resource "aws_lb" "main" {
  name               = "${var.prefix}alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.alb_logs.bucket
#     prefix  = "alb"
#     enabled = true
#   }
}

# ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }

  certificate_arn = "arn:aws:acm:us-east-1:433826697239:certificate/8bd9d11d-999d-41e7-a79d-6a69376d9ecf"
}

# ALB Listener for HTTP traffic on port 80
resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

# ALB Target Group
resource "aws_lb_target_group" "front_end" {
  name        = "${var.prefix}frontend-tg"
  port        = 5001
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
