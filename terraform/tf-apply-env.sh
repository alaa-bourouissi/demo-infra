#!/usr/bin/env bash

set -euo pipefail

# Couleurs pour rendre l'affichage plus lisible
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}    Choix de l'environnement Terraform    ${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""

echo "Quel environnement veux-tu appliquer ?"
echo "  1) dev"
echo "  2) uat"
echo "  3) prd"
echo ""
echo -n "Tape le numéro (1, 2 ou 3) : "

read -r choice

case $choice in
  1)
    ENV="dev"
    ;;
  2)
    ENV="uat"
    ;;
  3)
    ENV="prd"
    ;;
  *)
    echo -e "${RED}Choix invalide !${NC} Tape 1, 2 ou 3."
    exit 1
    ;;
esac

echo ""
echo -e "${YELLOW}Tu as choisi : ${ENV}${NC}"
echo ""

# Confirmation
read -p "Confirmer ? (O/n) : " confirm
if [[ $confirm =~ ^[Nn]$ ]]; then
  echo -e "${RED}Annulé.${NC}"
  exit 0
fi

echo ""
echo -e "${GREEN}Lancement de Terraform pour l'environnement : ${ENV}${NC}"
echo ""



# On sélectionne ou crée le workspace correspondant
terraform workspace select "${ENV}" 2>/dev/null || terraform workspace new "${ENV}"

echo ""
echo -e "${YELLOW}Workspace actif : $(terraform workspace show)${NC}"
echo ""

# Plan
echo -e "${GREEN}1. terraform plan${NC}"
terraform plan

echo ""
read -p "Voulez-vous appliquer ? (O/n) : " apply_confirm

if [[ $apply_confirm =~ ^[Oo]$ ]]; then
  echo -e "${GREEN}2. terraform apply${NC}"
  terraform apply
else
  echo -e "${YELLOW}Apply annulé.${NC}"
fi

echo ""
echo -e "${GREEN}Fin du script.${NC}"