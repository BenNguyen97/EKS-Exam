output "vpc_id" {
  value = aws_vpc.luan-vpc-25dec-01.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.luan-sn-public-01.id,
    aws_subnet.luan-sn-public-02.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.luan-sn-private-01.id,
    aws_subnet.luan-sn-private-02.id
  ]
}

output "eks_security_group_id" {
  description = "ID of the security group for EKS"
  value       = aws_security_group.eks_security_group.id
}