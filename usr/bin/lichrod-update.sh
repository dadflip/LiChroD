#!/bin/bash

# Afficher une boîte de dialogue pour confirmer la mise à jour
zenity --question --text="Voulez-vous mettre à jour les paquets?" --title="Confirmation de mise à jour"

# Vérifier la réponse de l'utilisateur
if [ $? -eq 0 ]; then
    sudo apt update && sudo apt upgrade -y
    sudo flatpak update -y
    zenity --info --text="Mise à jour terminée !" --title="Mise à jour réussie"
else
    zenity --info --text="Mise à jour annulée." --title="Mise à jour annulée"
fi
