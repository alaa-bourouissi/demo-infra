variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "demo-cluster"
}

variable "region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_version" {
  description = "Version Kubernetes"
  type        = string
  default     = "1.30"
}

variable "env" {
  description = "L'environnement : dev, uat ou prd"
  type        = string
  default     = "dev"   # valeur par défaut si tu oublies de la passer
}