# Create AWS EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "demo"
  role_arn = aws_iam_role.eks_master_role.arn
  version = var.cluster_version

  vpc_config {
    subnet_ids = module.vpc.public_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs    
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}