#!/bin/bash

# PROGRAMME DE TRI DE PHOTOS ET DE FILMS
# Création d'un système de dossiers 'annee-mois'
# Renommage des photos avec données EXIF (date de prise de la photo) 
# ou à défaut date de création du fichier
# REMARQUE : A Exécuter en une fois
# Nécessite : package exiv2 ( apt-get install exiv2 )

#-----------------------------------------------------------------------
# MESSAGE D'ACCUEIL + TRAITEMENT DES PARAMETRES D'ENTREE
#-----------------------------------------------------------------------

# Sélection du répertoire à trier avec Zenity
a=$(zenity --file-selection --directory --title="Sélectionnez le répertoire à trier")
if [[ -z "$a" ]]; then
    zenity --error --text="Aucun répertoire sélectionné. Le programme va maintenant se terminer."
    exit 1
fi

# Zenity input dialog for the target directory name
b=$(zenity --entry --title="Nom (chemin d'accès complet!) du répertoire trié" --text="Entrez le nom du répertoire trié:")
if [[ -z "$b" ]]; then
    zenity --error --text="Aucun nom de répertoire trié spécifié. Le programme va maintenant se terminer."
    exit 1
fi

NON_TRIE=$a
TRIE=$b

# Confirmation dialog using Zenity
zenity --question --title="Confirmation" --text="Source : $a\nDest : $b\n\nContinuer ?"
if [[ $? -ne 0 ]]; then
    exit 0
fi

DIR=$(dirname $TRIE)	
TMP="$DIR/TMP"			# un répertoire TMP à côté de TRIE

mkdir -p $TMP 	# -p : si dossier inexistant, création
mkdir -p $TRIE
#-----------------------------------------------------------------------
# CREATION DU SYSTEME DE DOSSIERS TRIES 
# [ANNEE]-[MOIS]
#-----------------------------------------------------------------------
for annee in `seq 2000 2030`;
do
	for mois in `seq 01 12`;
	do
		if [ $mois -lt 10 ] 				# si mois < 10
		then concat="$annee"-0"$mois"		#[ANNEE]-0[MOIS]
		else concat="$annee"-"$mois"		#[ANNEE]-[MOIS]
		fi
	
	mkdir $TRIE/$concat
	done	

done;

#-----------------------------------------------------------------------
# SUPPRESSION DES ESPACES DANS LES NOMS DE FICHIERS/DOSSIERS À TRIER 
#-----------------------------------------------------------------------
# Remplace les espaces par des underscores
# À exécuter plusieurs fois pour tous les niveaux de répertoires

echo "SUPPRESSION DES ESPACES DANS LES NOMS DE FICHIERS/DOSSIERS À TRIER"

for COUNT in $(seq 1 6); do
    find "$NON_TRIE" -type d -exec rename 's/ /_/g' {} \;
done

#-----------------------------------------------------------------------
# RENOMMAGE DES FICHIERS AVEC UN SUFFIXE POUR ÉVITER LES DOUBLONS
#-----------------------------------------------------------------------
# Plusieurs fichiers placés dans différents répertoires
# peuvent avoir le même nom. Une solution consiste à les renommer
# avec un suffixe pseudo-aléatoire.

echo "RENOMMAGE DES FICHIERS AVEC UN SUFFIXE POUR ÉVITER LES DOUBLONS"

COUNT=0

for FILE in $(find "$NON_TRIE/" -type f); do
    if [ -f "$FILE" ]; then
        extension=${FILE##*.}           # Récupération de l'extension du fichier
        BASEN=$(basename "$FILE")
        BASEN=${BASEN:0:15}             # On limite le nom à 15 caractères
        DIR=$(dirname "$FILE")
        mv "$FILE" "$DIR/$BASEN"$(printf "%03d" "$COUNT")."$extension"
        echo "$FILE" "$DIR/$BASEN"$(printf "%03d" "$COUNT")."$extension"
        
        COUNT=$((COUNT+1))
        if [ $COUNT -gt 999 ]; then
            COUNT=0
        fi
    fi
done

#-----------------------------------------------------------------------
# COPIE ET RENOMMAGE EXIF DES FICHIERS (pour ceux dont c'est possible)
# NON_TRIE --> TMP
#-----------------------------------------------------------------------
echo "COPIE ET RENOMMAGE EXIF DES FICHIERS"

for FILE in $(find "$NON_TRIE/" -type f); do
    BASEN=$(basename "$FILE")
    
    cp -av "$FILE" "$TMP"             # Copie de tous les fichiers dans TEMP
    exiv2 -F rename "$TMP/$BASEN"     # Permet de récupérer les infos EXIF (date de la photo)
done

#-----------------------------------------------------------------------
# DEPLACEMENT DES FICHIERS TMP --> TRIES
#-----------------------------------------------------------------------
for FILE in $(find "$TMP" -type f); do
    BASEN=$(basename "$FILE")
    BASEN=${BASEN:0:4}-${BASEN:4:2}   # [ANNEE]-[MOIS]
    # ${BASEN:i:j}: à partir du ième caractère, on affiche j caractères
    echo "$BASEN"
    mv "$FILE" "$TRIE/$BASEN/"
done

#-----------------------------------------------------------------------
# pour ceux dont le nom n'a pas été modifié avec exiv2
# récupération de la date de création du fichier (à défaut de mieux)
#-----------------------------------------------------------------------
for FILE in ` find $TMP -type f ` ;
do
echo $FILE
date=`stat -c %y $FILE | awk '{printf $1 "\n"}'` # Date de création du fichier
echo $date
date=${date:0:7}	# on ne conserve que [annee]-[mois]
echo $date
mv $FILE $TRIE/$date*
done;
#-----------------------------------------------------------------------
# Suppression des Dossiers Vides dans TRIE
#-----------------------------------------------------------------------

find "$TRIE" -empty -type d -printf "%f est VIDE et supprimé\n" -exec rmdir {} \; 2>/dev/null
rm -r "$TMP"  # Suppression de TMP

#-----------------------------------------------------------------------
# Suppression des Fichiers inutiles (liste non exhaustive)
#-----------------------------------------------------------------------

# Suppression des fichiers avec certaines extensions inutiles
for FILE in $(find "$TRIE" -type f \( -name "*.rar" -o -name "*.exe" -o -name "*.zip" -o -name "*.gz" -o -name "*.db" \)); do
    echo "$FILE"
    rm "$FILE"
done

#-----------------------------------------------------------------------
#		SUPPRESSION DES DOUBLONS
#-----------------------------------------------------------------------

# Pour une raison encore indéterminée, certains doublons apparaissent
# avec le suffixe _i

mkdir -p "$TRIE/Doublons"

for FILE in $(find "$TRIE/" -type f); do
    BASEN=$(basename "$FILE")
    DERNIERES_LETTRES=${BASEN:(-6)} # ou ${BASEN: -6}

    for i in $(seq 1 5); do
        if [ "$DERNIERES_LETTRES" == "_$i.JPG" ] || [ "$DERNIERES_LETTRES" == "_$i.jpg" ]; then
            mv -v "$FILE" "$TRIE/Doublons/"
        fi
    done
done








