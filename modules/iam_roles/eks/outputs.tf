output "task_execution_role_eks_cluster_arn" {
  value = aws_iam_role.eks_role.arn
}

output "task_execution_role_eks_node_arn" {
  value = aws_iam_role.eks_node_role.arn
}

