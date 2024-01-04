#!/bin/bash

# Fonction pour afficher un message de statut
display_status() {
    zenity --info --title="Statut" --text="$1"
}

# Afficher une boite de dialogue Zenity pour le choix du mode d'attaque
attackmd=$(zenity --list --title="Choisir un mode d'attaque" --text="Selectionnez un mode d'attaque :" \
    --column="Mode" --column="Description" \
    0 "Straight (dictionnaire)" \
    1 "Combination (Combinaison)" \
    3 "Brute-force" \
    6 "Hybrid Wordlist + Mask" \
    7 "Hybrid Mask + Wordlist (hybride)")

if [ $? -ne 0 ]; then
    display_status "Operation annulee par l'utilisateur."
    exit 1
fi

# Fonction pour afficher un message de statut
display_status() {
    zenity --info --title="Statut" --text="$1"
}

# Tableau des algorithmes de Hashcat avec leurs numeros
algorithms_table=(
    "0" "MD5"
    "100" "SHA1"
    "1400" "SHA256"
    "1700" "SHA512"
    # Ajouter plus d'algorithmes ici si necessaire
)

# Construire la liste des descriptions d'algorithmes pour Zenity
algorithms_list=""
for ((i=0; i<${#algorithms_table[@]}; i+=2)); do
    algorithms_list+="${algorithms_table[$i]} - ${algorithms_table[$i+1]}\n"
done

# Ajouter l'option "Autres algorithmes"
algorithms_list+="OTHER - Autres algorithmes\n"

# Demander a l'utilisateur de choisir un algorithme
algo=$(zenity --entry --title="Choisir un algorithme" --text="Selectionnez un algorithme (numero) :\n$algorithms_list" --entry-text="0")

if [ $? -ne 0 ]; then
    display_status "Operation annulee par l'utilisateur."
    exit 1
fi

# Afficher les informations pour acceder aux autres algorithmes
if [ "$algo" = "OTHER" ]; then
    ( hashcat --help ) | zenity --text-info --title="Algorithmes Hashcat"
    display_status "Consultez la sortie ci-dessus pour acceder aux autres algorithmes de Hashcat."
    exit 0
fi

# Demander a l'utilisateur de fournir le nom du fichier de sortie
output_file=$(zenity --entry --title="Nom du fichier de sortie" --text="Entrez le nom du fichier de sortie :")

# Afficher une boite de dialogue Zenity pour entrer les masques
mask_info="Liste des masques disponibles:\n\n
?l = abcdefghijklmnopqrstuvwxyz\n
?u = ABCDEFGHIJKLMNOPQRSTUVWXYZ\n
?d = 0123456789\n
?h = 0123456789abcdef\n
?H = 0123456789ABCDEF\n
?s = Caracteres speciaux\n
?a = ?l?u?d?s\n
?b = 0x00 - 0xff"

masks=$(zenity --entry --title="Masque(s) format" --text="$mask_info\n\nEntrez le(s) masque(s) au format ?X?X?X... :")

# Demander a l'utilisateur de fournir le nom/chemin d'acces du fichier contenant le mot de passe hashe
mdp=$(zenity --file-selection --title="Selectionner le fichier de mots de passe hases")

# Demander a l'utilisateur de fournir le chemin d'acces du dictionnaire
dict=$(zenity --file-selection --title="Selectionner le fichier de dictionnaire")

# Demander a l'utilisateur s'il veut supprimer le fichier de hachage
choice=$(zenity --question --title="Supprimer le fichier de hachage" --text="Voulez-vous supprimer le fichier de hachage ?" --ok-label="Oui" --cancel-label="Non")

if [ "$choice" = "Yes" ]; then
    hashrm="--remove"
else
    hashrm=""
fi

case "$attackmd" in
    "0")
        (hashcat -m $algo -a $attackmd -O -o $output_file $hashrm $mdp $dict) | zenity --text-info --title="Hashcat run..."
        ;;
    "1")
        (hashcat -m $algo -a $attackmd -O -o $output_file $hashrm $mdp $dict dico_transpo.txt) | zenity --text-info --title="Hashcat run..."
        ;;
    "3")
        min=$(zenity --entry --title="Nombre de caracteres min (mot de passe hashe)" --text="Entrez le nombre de caracteres minimum :")
        max=$(zenity --entry --title="Nombre de caracteres max (mot de passe hashe)" --text="Entrez le nombre de caracteres maximum :")
        (hashcat -m $algo -a $attackmd -O -o $output_file $hashrm $mdp -i --increment-min $min --increment-max $max) | zenity --text-info --title="Hashcat run..."
        ;;
    "6")
        (hashcat -m $algo -a $attackmd -O -o $output_file $hashrm $mdp $dict $masks) | zenity --text-info --title="Hashcat run..."
        ;;
    "7")
        (hashcat -m $algo -a $attackmd -O -o $output_file $hashrm $mdp $masks $dict) | zenity --text-info --title="Hashcat run..."
        ;;
    *)
        (zenity --error --text="Option invalide choisie.") | zenity --text-info --title="Hashcat run..."
        ;;
esac

# Afficher un message de fin
display_status "Operations terminees avec succes."

