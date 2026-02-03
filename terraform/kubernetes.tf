# kubernetes.tf


# Provider Kubernetes : il utilise les infos du cluster EKS que Terraform crée
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  # Authentification : utilise aws-cli pour générer le token (comme kubectl)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
      "--region",
      var.region
    ]
  }
}

# Ressource Namespace : créé le namespace avec le nom de l'environnement
resource "kubernetes_namespace_v1" "app_namespace" {
  metadata {
    name = var.env   # dev, uat ou prd
  }

  # Optionnel : ajoute des labels
  depends_on = [module.eks]   # assure que le cluster existe avant
}