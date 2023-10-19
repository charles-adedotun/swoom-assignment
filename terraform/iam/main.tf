# ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.prefix}ecs-execution-role"
  assume_role_policy = file("${path.module}/ecs_execution_assume_role.json")
}

# Attach the default Amazon ECS task execution role policy
resource "aws_iam_role_policy_attachment" "ecs_execution_role_default" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom IAM policy for ECS to publish logs to CloudWatch
resource "aws_iam_policy" "ecs_cloudwatch_logs" {
  name        = "${var.prefix}ecs-cloudwatch-logs-policy"
  description = "Allows ECS tasks to publish logs to CloudWatch."
  policy      = file("${path.module}/ecs_execution_policy.json")
}

# Attach custom IAM policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_logs" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_cloudwatch_logs.arn
}
