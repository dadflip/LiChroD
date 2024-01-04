#!/bin/bash

# Afficher un message à l'utilisateur avec Zenity
zenity --info --text="Entrez 'doxywizard' dans un terminal pour lancer l'application !" --title="Lancement de l'application"

# Afficher une boîte de dialogue pour confirmer la fin
zenity --question --text="Terminer ?" --title="Confirmation de fin"

# Vérifier la réponse de l'utilisateur
if [ $? -eq 0 ]; then
    exit
fi

