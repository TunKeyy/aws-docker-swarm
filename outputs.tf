output "instance_ips" {
  value = aws_instance.swarm_nodes[*].public_ip
}

output "instance_ids" {
  value = aws_instance.swarm_nodes[*].id 
}