#!/bin/bash

# Afficher une boîte de dialogue avec Zenity pour choisir l'action
VAR=$(zenity --list --title="APTITUDE PACKAGE MANAGER - ACTIONS" --text="Choisissez une action:" --column="Action" "list" "search" "show" "install" "reinstall" "remove" "autoremove" "update" "upgrade" "full-upgrade" "edit-sources" "satisfy")

if [ -n "$VAR" ]; then
    if [ "$VAR" == "install" ]; then
        PACKAGE=$(zenity --entry --title="Installation de paquet" --text="Entrez le nom du paquet à installer:")
        if [ -n "$PACKAGE" ]; then
            xterm -e "sudo apt install '$PACKAGE' && read"
        fi
    elif [ "$VAR" == "search" ]; then
        PACKAGE=$(zenity --entry --title="Recherche de paquet" --text="Entrez le nom du paquet à rechercher:")
        if [ -n "$PACKAGE" ]; then
            xterm -e "sudo apt search '$PACKAGE' && read"
        fi
    elif [ "$VAR" == "show" ]; then
        PACKAGE=$(zenity --entry --title="Affichage des détails du paquet" --text="Entrez le nom du paquet à afficher:")
        if [ -n "$PACKAGE" ]; then
            xterm -e "sudo apt show '$PACKAGE' && read"
        fi
    elif [ "$VAR" == "reinstall" ] || [ "$VAR" == "remove" ] || [ "$VAR" == "autoremove" ]; then
        PACKAGE=$(zenity --entry --title="Gestion de paquets" --text="Entrez le nom du paquet à traiter:")
        if [ -n "$PACKAGE" ]; then
            xterm -e "sudo apt '$VAR' '$PACKAGE' && read"
        fi
    elif [ "$VAR" == "update" ] || [ "$VAR" == "upgrade" ] || [ "$VAR" == "full-upgrade" ]; then
        xterm -e "sudo apt '$VAR' && read"
    elif [ "$VAR" == "edit-sources" ]; then
        xterm -e "sudo nano /etc/apt/sources.list && read"
    elif [ "$VAR" == "satisfy" ]; then
        xterm -e "sudo apt '$VAR' && read"
    else
        # Pour les actions sans saisie
        xterm -e "sudo apt '$VAR' && read"
    fi
fi

# Afficher une boîte de dialogue pour terminer le script
zenity --info --title="Terminé" --text="Le script est terminé."

exit

