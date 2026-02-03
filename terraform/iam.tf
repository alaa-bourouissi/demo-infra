# Rôle IAM pour Terraform (utilisé par GitHub Actions ou CI/CD)
resource "aws_iam_role" "terraform_executor" {
  name = "terraform-${var.env}-executor"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/dev-cli"  # ton utilisateur actuel pour le premier run
        }
      },
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:alaa-bourouissi/demo-infra:*"
          }
        }
      }
    ]
  })
}

# Attache les droits nécessaires au rôle Terraform
resource "aws_iam_role_policy_attachment" "terraform_executor_eks" {
  role       = aws_iam_role.terraform_executor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "terraform_executor_ecr" {
  role       = aws_iam_role.terraform_executor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# ... ajoute d’autres policies si besoin (IAMFullAccess pour créer d’autres rôles, etc.)