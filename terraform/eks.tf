module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = "demo-cluster-${var.env}"
  cluster_version = var.cluster_version

  vpc_id = "vpc-01d1ce27b6351f9eb"
  subnet_ids = ["subnet-07dd66ece44ed296a","subnet-03a5593eedd5d927c","subnet-0ae0e63f00171aaf9"]  # ← tes subnets privés/publics

  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # Si tu veux aussi garder l’accès privé (recommandé)
  cluster_endpoint_private_access = true

  fargate_profiles = {
    "${var.env}" = {
      name = "${var.env}-profile"
      selectors = [
        {
          namespace = var.env
          labels = {
            app = "demo-app"
          }
        }
      ]
    }
  }

  # Ajoute d'autres configs si besoin (roles IAM, addons, etc.)
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}