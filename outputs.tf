output "ec2_global_ips_Jenkins_GMD" {
  value = [for instance in aws_instance.jenkins_gmd_instance : instance.public_ip]
}

output "ec2_global_ips_Ansible_Instance" {
  value = [for instance in aws_instance.ansible_instance : instance.public_ip]
}

output "ec2_global_ips_Kubernetes_Instance" {
  value = [for instance in aws_instance.kubernetes_instance : instance.public_ip]
}

