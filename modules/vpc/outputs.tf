output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}
