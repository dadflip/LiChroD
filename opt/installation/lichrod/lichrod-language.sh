#!/bin/bash

# Fonction pour afficher un message de statut
display_status() {
    echo -e "\n==> $1"
}

# Afficher une boite de dialogue avec les options de langues
lang_choice=$(zenity --list --radiolist \
    --title="Selectionnez votre langue" \
    --text="Selectionnez votre langue :" \
    --column="Selection" --column="Langue" \
    TRUE "Anglais britannique (en_GB)" \
    FALSE "Francais (fr_FR)" \
    FALSE "Allemand (de_DE)" \
    FALSE "Portugais (pt_PT)" \
    FALSE "Espagnol (es_ES)" \
    FALSE "Suedois (sv_SE)" \
    FALSE "Danois (da_DK)" \
    FALSE "Norvegien (nb_NO)" \
    FALSE "Finnois (fi_FI)")

# Configurer la langue en fonction de la selection de l'utilisateur
case "$lang_choice" in
    "Anglais britannique (en_GB)") LANGUAGE="en_GB" ;;
    "Francais (fr_FR)") LANGUAGE="fr_FR" ;;
    "Allemand (de_DE)") LANGUAGE="de_DE" ;;
    "Portugais (pt_PT)") LANGUAGE="pt_PT" ;;
    "Espagnol (es_ES)") LANGUAGE="es_ES" ;;
    "Suedois (sv_SE)") LANGUAGE="sv_SE" ;;
    "Danois (da_DK)") LANGUAGE="da_DK" ;;
    "Norvegien (nb_NO)") LANGUAGE="nb_NO" ;;
    "Finnois (fi_FI)") LANGUAGE="fi_FI" ;;
    *) LANGUAGE="fr_FR" ;;  # Langue par defaut en cas de selection incorrecte
esac

# Ecrire la configuration de la langue dans le fichier /etc/default/locale
display_status "Configuration de la langue..."
echo -e "LANGUAGE=$LANGUAGE\nLC_ALL=$LANGUAGE\n" | sudo tee /etc/default/locale
display_status "Configuration terminee."

# Afficher une boite de dialogue pour signaler la fin du script
zenity --info --text="Operation terminee avec succes." --title="Succes"
