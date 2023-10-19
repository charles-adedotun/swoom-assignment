output "alb_url" {
  description = "URL of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

# alb/outputs.tf

# Output ALB details
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

# Output ALB Listener details
output "listener_arn" {
  description = "ARN of the ALB Listener for front_end"
  value       = aws_lb_listener.front_end.arn
}

# Output ALB Target Group details
output "target_group_arn" {
  description = "ARN of the ALB Target Group for front_end"
  value       = aws_lb_target_group.front_end.arn
}

output "target_group_name" {
  description = "Name of the ALB Target Group for front_end"
  value       = aws_lb_target_group.front_end.name
}
