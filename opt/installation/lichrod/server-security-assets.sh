#!/bin/bash

CURRENT_DIR=$(pwd)

# Variables
BINARIES_DIRECTORY="/usr/bin"
BOOT_DIRECTORY="/boot"
DEV_DIRECTORY="/dev"
ETC_DIRECTORY="/etc"
HOME_DIRECTORY="/home"
LIB_DIRECTORY="/lib"
LIB64_DIRECTORY="/lib64"
MNT_DIRECTORY="/mnt"
MEDIA_DIRECTORY="/media"
OPT_DIRECTORY="/opt"
PROC_DIRECTORY="/proc"
ROOT_DIRECTORY="/root"
RUN_DIRECTORY="/run"
SBIN_DIRECTORY="/sbin"
SRV_DIRECTORY="/srv"
SYS_DIRECTORY="/sys"
TMP_DIRECTORY="/tmp"
USR_DIRECTORY="/usr"
VAR_DIRECTORY="/var"

MYAPP="$OPT_DIRECTORY/myapp"
MYAPP_MODULES="$MYAPP/modules"

HOME_LICHROD="/home/$USER/.lichrod"

# Fonction pour afficher un message avec Zenity
show_message() {
    zenity --info --text="$1" --title="Installation"
}

# Installer Git
show_message "Installation de Git en cours..."
sudo apt install git

# Créer un fichier index.php avec du code PHP qui affiche "Hello"
show_message "Creation du fichier index.php..."
sudo touch /var/www/html/index.php
echo "<?php
    echo 'Hello';
?>" | sudo tee /var/www/html/index.php

show_message "Suppression du fichier index.html..."
sudo rm /var/www/html/index.html

# Mettre à jour les dépôts et installer Crowdsec
show_message "Mise a jour des depots en cours..."
sudo apt-get update
show_message "Installation de Crowdsec en cours..."
sudo apt-get install -y crowdsec

# Activer Crowdsec au démarrage
show_message "Activation de Crowdsec au demarrage..."
sudo systemctl enable crowdsec

# Utiliser xterm pour changer de répertoire
cd $HOME_LICHROD/libs

# Cloner le dépôt de Nikto depuis GitHub
show_message "Clonage du depot de Nikto depuis GitHub..."
git clone https://github.com/sullo/nikto

# Se déplacer dans le répertoire Logiciels et mettre à jour les dépôts
show_message "Mise a jour des depots en cours..."
sudo apt-get update
show_message "Installation de PHP-CLI et Unzip en cours..."
sudo apt-get install -y php-cli unzip

# Se déplacer dans le répertoire personnel et télécharger l'installeur de Composer
show_message "Telechargement de l'installeur de Composer..."
curl -sS https://getcomposer.org/installer -o composer-setup.php

# Vérifier l'intégrité de l'installeur de Composer
show_message "Verification de l'integrite de l'installeur de Composer..."
HASH=`curl -sS https://composer.github.io/installer.sig`
verification_result=$(php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'verified'; } else { echo 'corrupt'; unlink('composer-setup.php'); }")
show_message "Resultat de la verification de l'installeur de Composer : $verification_result"

# Installer Composer
show_message "Installation de Composer..."
chmod +x composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Se déplacer dans le répertoire cs-php-bouncer et exécuter l'installeur d'Apache
show_message "Installation d'Apache avec cs-php-bouncer..."
git clone https://github.com/crowdsecurity/cs-php-bouncer.git
cd $HOME_LICHROD/libs/cs-php-bouncer/
(echo "Pour la suite de l'installation veuillez visiter le site: https://github.com/crowdsecurity/cs-standalone-php-bouncer/blob/main/docs/INSTALLATION_GUIDE.md") | zenity --text-info --title="Information"

# Modifier les propriétés de /usr/local/php/crowdsec/ pour qu'Apache en ait la propriété
#show_message "Modification des propriétés de /usr/local/php/crowdsec/ pour qu'Apache en ait la propriété..."
#sudo chown www-data /usr/local/php/crowdsec/

# Redémarrer Apache
show_message "Redemarrage d'Apache..."
sudo systemctl reload apache2

# Utiliser xterm pour se déplacer dans le répertoire personnel
cd $HOME

# Se déplacer dans le répertoire Logiciels et copier nikto et cs-php-bouncer dans /opt/
show_message "Copie de nikto et cs-php-bouncer dans /opt/..."
cd $HOME_LICHROD/libs
sudo cp -r $HOME_LICHROD/libs/nikto/ /opt/
sudo cp -r $HOME_LICHROD/libs/cs-php-bouncer/ /opt/

# Créer un fichier contenant les instructions pour utiliser nikto et crowdsec
show_message "Creation d'un fichier contenant les instructions pour utiliser nikto et crowdsec..."
echo "Les outils de securisation de votre serveur web sont installes! Pour la suite de l'installation veuillez vous referer a la documentation en ligne" | tee /home/$USER/READ_ME_LICHROD/Utiliser_nikto_et_crowdsec
 
 
 
 
 
 
