#!/bin/bash

# Utilitaire Zenity pour les boîtes de dialogue
ZENITY=$(which zenity)

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


# Fonction pour afficher une boîte de dialogue de choix des répertoires
choose_directory() {
    local result
    result=$($ZENITY --file-selection --directory --title="Choisissez un repertoire")
    echo "$result"
}

# Utilisation de Zenity pour choisir le répertoire de l'application
#MYAPP_DIR=$(choose_directory)

# Affichage de la boîte de dialogue de début d'installation
zenity --info --text="Debut de l'installation de MariaDB et PHPMyAdmin." --title="Installation"

(# Mettre à jour la liste des paquets
sudo apt-get update

# Activer le module Apache2
sudo systemctl enable apache2

# Activer les modules Apache2 nécessaires
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod ssl

# Redémarrer Apache2
sudo systemctl restart apache2

# Installer les utilitaires Apache2
sudo apt-get install -y apache2-utils

# Installer PHP
sudo apt-get install -y php

# Installer les modules PHP nécessaires
sudo apt-get install -y php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# Installer MariaDB
sudo apt-get install -y mariadb-server

echo "TERMINE" ) | zenity --text-info --title="Processus d'installation"

# Utilisation de Zenity pour afficher un message de fin
zenity --info --text="L'installation de mariadb est terminee." --title="Installation MariaDB Terminee"


# Affichage de la boîte de dialogue de début de sécurisation
zenity --info --text="Securisation de MariaDB" --title="Securisation"

# Affichage des etapes de la procedure
zenity --info \
--width=800 \
--height=400 \
--text="Ce script vous guidera dans la procedure de securisation de votre base de donnees MariaDB. Il est recommande de suivre cette procedure pour proteger votre base de donnees contre les attaques.\n\nVoici les etapes de la procedure :\n1. Entrer le mot de passe actuel pour la base mariadb (appuyez sur entree si vous n'en avez pas)\n2. Choisir si vous voulez utiliser l'authentification par socket Unix (appuyez sur n si vous ne savez pas ce que c'est)\n3. Choisir si vous voulez changer le mot de passe root (appuyez sur Y si vous le souhaitez)\n4. Saisir le nouveau mot de passe et le confirmer\n5. Choisir si vous voulez supprimer les utilisateurs anonymes (appuyez sur Y si vous le souhaitez)\n6. Choisir si vous voulez empecher la connexion root a distance (appuyez sur Y si vous le souhaitez)\n7. Choisir si vous voulez supprimer la base de donnees de test et l'acces a celle-ci (appuyez sur Y si vous le souhaitez)\n8. Choisir si vous voulez recharger les tables de privileges maintenant (appuyez sur Y si vous le souhaitez)" \
--title="Etapes"

# Utilisation de Zenity pour confirmer la poursuite
zenity --info --text="Appuyez sur OK pour continuer..." --title="Continuer"

# Lancer la fenetre xterm avec les commandes
xterm -e "sudo mariadb-secure-installation && echo 'La procedure de securisation de MariaDB est terminee.' && $ZENITY --info --text='La procedure de securisation de MariaDB est terminee.' --title='Termine' && sudo systemctl restart mariadb"

(# Télécharger la dernière version de phpMyAdmin
xterm -e "sudo wget -q 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip' -P /tmp"

# Décompresser l'archive téléchargée
xterm -e "sudo unzip -qq '/tmp/phpMyAdmin-latest-all-languages.zip' -d /tmp"

# Rechercher le dossier dans /tmp
found_dir=$(find /tmp -maxdepth 1 -type d -name "phpMyAdmin-*all-languages" -print -quit)

# Vérifier si le dossier a été trouvé
if [ -n "$found_dir" ]; then
    # Déplacer l'application dans le répertoire /usr/share
    sudo mv "$found_dir" /usr/share/phpmyadmin
else
    echo "Dossier phpMyAdmin introuvable dans /tmp."
fi

# Créer un répertoire temporaire pour l'application
sudo mkdir -p /var/lib/phpmyadmin/tmp/

# Donner les droits d'accès à l'utilisateur www-data
sudo chown -R www-data:www-data /var/lib/phpmyadmin/

# Copier le fichier de configuration de base
sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php 

echo "termine ! ") | zenity --text-info --title="Processus d'installation"

zenity --info --text="Installation de phpMyAdmin terminee !" --title="Termine"


# Affichage de la boîte de dialogue de début de configuration
zenity --info --text="Configuration de phpMyAdmin" --title="Configuration"

# Texte à afficher dans la fenêtre Zenity
config_steps=$(cat <<EOF
Voici les etapes a suivre pour configurer phpMyAdmin :

1. Generer une cle de securite pour votre installation de phpMyAdmin en tapant la commande suivante :
   openssl rand -base64 32
   Copiez la valeur retournee, elle sera utilisee dans le fichier de configuration de phpMyAdmin.

2. Ouvrez le fichier de configuration de phpMyAdmin avec un editeur de texte nano en tapant la commande suivante :
   sudo nano /usr/share/phpmyadmin/config.sample.inc.php

3. Collez la valeur de la cle de securite a la ligne suivante :
   '\$'cfg['blowfish_secret'] = 'votre_cle';

4. Definissez un nom utilisateur et un mot de passe pour acceder a votre base de donnees phpMyAdmin en modifiant les lignes suivantes :
   '\$'cfg['Servers']['\$'i]['controluser'] = 'nom_d_utilisateur';
   '\$'cfg['Servers']['\$'i]['controlpass'] = 'mot_de_passe';

5. Decommentez les lignes suivantes (en supprimant les doubles slashs) et arretez-vous apres avoir decommente '\$'cfg['SaveDir'] = '';
   /* Storage database and tables */

6. Ajoutez cette ligne juste apres :
   '\$'cfg['TempDir'] = '/var/lib/phpmyadmin/tmp/';

7. Sauvegardez et fermez le fichier en utilisant les touches Ctrl+X, puis Y, puis Entree.
EOF
)

# Afficher les étapes de configuration
zenity --info \
--width=800 \
--height=400 \
--text="$config_steps" \
--title="Etapes de Configuration"

# Demander à l'utilisateur s'il souhaite continuer
zenity --info --text="Continuer avec la configuration de phpMyAdmin ?" --title="Continuer"

# Générer la clé de sécurité
blowfish_secret=$(openssl rand -base64 32)

# Chemin du fichier de configuration de phpMyAdmin
config_file="/usr/share/phpmyadmin/config.inc.php"

# Fonction pour afficher un dialogue Zenity et obtenir une nouvelle valeur
get_new_value() {
    zenity --entry --text="$1" --entry-text="$2"
}

# Fonction pour modifier une variable dans le fichier de configuration
modify_variable() {
    variable_name="$1"
    current_value="$2"
    new_value=$(get_new_value "Modifier la variable $variable_name" "$current_value")
    
    if [ -n "$new_value" ]; then
        xterm -e "sudo sed -i 's/\($variable_name *= *\).*\$/\1$new_value;/' '$config_file'"
    fi
}

# Fonction pour décommenter une ligne dans le fichier de configuration
uncomment_line() {
    variable_name="$1"
    xterm -e "sudo sed -i 's/^\/\/ \(.*$variable_name.*\)$/\1/' '$config_file'"
}

# Modifier les variables une par une
modify_variable "\$cfg['blowfish_secret']" "$blowfish_secret"
modify_variable "\$cfg['Servers'][\$i]['auth_type']" "cookie"
modify_variable "\$cfg['Servers'][\$i]['host']" "localhost"
modify_variable "\$cfg['Servers'][\$i]['compress']" "false"
modify_variable "\$cfg['Servers'][\$i]['AllowNoPassword']" "false"
modify_variable "\$cfg['Servers'][\$i]['controlhost']" ""
modify_variable "\$cfg['Servers'][\$i]['controlport']" ""
modify_variable "\$cfg['Servers'][\$i]['controluser']" "pma"
modify_variable "\$cfg['Servers'][\$i]['controlpass']" "pmapass"

# Décommenter les lignes
uncomment_line "\$cfg['Servers'][\$i]['pmadb']"
uncomment_line "\$cfg['Servers'][\$i]['bookmarktable']"
uncomment_line "\$cfg['Servers'][\$i]['relation']"
uncomment_line "\$cfg['Servers'][\$i]['table_info']"
uncomment_line "\$cfg['Servers'][\$i]['table_coords']"
uncomment_line "\$cfg['Servers'][\$i]['pdf_pages']"
uncomment_line "\$cfg['Servers'][\$i]['column_info']"
uncomment_line "\$cfg['Servers'][\$i]['history']"
uncomment_line "\$cfg['Servers'][\$i]['table_uiprefs']"
uncomment_line "\$cfg['Servers'][\$i]['tracking']"
uncomment_line "\$cfg['Servers'][\$i]['userconfig']"
uncomment_line "\$cfg['Servers'][\$i]['recent']"
uncomment_line "\$cfg['Servers'][\$i]['favorite']"
uncomment_line "\$cfg['Servers'][\$i]['users']"
uncomment_line "\$cfg['Servers'][\$i]['usergroups']"
uncomment_line "\$cfg['Servers'][\$i]['navigationhiding']"
uncomment_line "\$cfg['Servers'][\$i]['savedsearches']"
uncomment_line "\$cfg['Servers'][\$i]['central_columns']"
uncomment_line "\$cfg['Servers'][\$i]['designer_settings']"
uncomment_line "\$cfg['Servers'][\$i]['export_templates']"

# Informer que la configuration a été modifiée
zenity --info --text="Certaines lignes ont ete decommentees dans la configuration."


modify_variable "\$cfg['UploadDir']" ""
modify_variable "\$cfg['SaveDir']" ""


# Informer que la configuration a été modifiée
zenity --info --text="La configuration a ete mise a jour."

zenity --info --text="Configuration de phpMyAdmin terminee !" --title="Termine"

# Afficher les instructions initiales
zenity --info --text="Avant de continuer, assurez-vous d'avoir execute les etapes de configuration de phpMyAdmin comme indique precedemment." --title="Instructions Prealables"

# Afficher les etapes de creation des utilisateurs de Mariadb
zenity --info \
--width=800 \
--height=400 \
--text="Pour creer les utilisateurs de Mariadb, suivez ces etapes :\n\n\
1. Connectez-vous a la console de Mariadb en tapant la commande suivante :\n\
   mysql -u root -p\n\n\
2. Executez les commandes suivantes dans la console pour creer un utilisateur ayant acces a la base de donnees de phpMyAdmin :\n\
   CREATE USER 'nom_utilisateur'@'localhost' IDENTIFIED BY 'mot_de_passe';\n\
   GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'nom_utilisateur'@'localhost' WITH GRANT OPTION;\n\
   FLUSH PRIVILEGES;\n\n\
3. Executez les commandes suivantes dans la console pour creer un administrateur ayant acces a toutes les bases de donnees :\n\
   CREATE USER 'nom_admin'@'localhost' IDENTIFIED BY 'mot_de_passe_admin';\n\
   GRANT ALL PRIVILEGES ON *.* TO 'nom_admin'@'localhost' WITH GRANT OPTION;\n\
   FLUSH PRIVILEGES;\n\n\
Utilisateurs crees avec succes !" \
--title="Etapes de Creation des Utilisateurs de Mariadb"

# Demander l'exécution des commandes dans la console Mariadb
zenity --info --text="Voulez-vous executer les commandes dans la console Mariadb maintenant (il vous faudra entrer votre mot de passe root pour executer chaque commande ! S'il n'est pas defini, definissez le avec 'sudo passwd root') ?" --title="Execution des Commandes"

# Demander les noms d'utilisateur et les mots de passe
user=$(zenity --entry --title="Nom de l'utilisateur" --text="Entrez le nom de l'utilisateur pour la base de donnees phpMyAdmin :")
password=$(zenity --password --title="Mot de passe" --text="Entrez le mot de passe pour l'utilisateur $user :")
admin=$(zenity --entry --title="Nom de l'administrateur" --text="Entrez le nom de l'administrateur :")
password2=$(zenity --password --title="Mot de passe" --text="Entrez le mot de passe pour l'administrateur $admin :")


# Générer les commandes SQL
commands=$(cat <<EOF
CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON phpmyadmin.* TO '$user'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE USER '$admin'@'localhost' IDENTIFIED BY '$password2';
GRANT ALL PRIVILEGES ON *.* TO '$admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
)

zenity --info --text="Veuillez copier les commandes suivantes dans MariaDB" 

# Afficher les commandes dans un champ Zenity avec instructions pour copier manuellement
zenity --info --title="Commandes SQL pour MariaDB" --width=600 --height=400 --text="Copiez les commandes suivantes et executez-les dans MariaDB :

$commands"


terminator -e "echo 'CONSOLE MARIADB' && sudo mariadb" 

zenity --info --text="Commandes executees avec succes !" --title="Termine"

#mysql -u root -p

echo -e "Alias /pma /usr/share/phpmyadmin \n

<Directory /usr/share/phpmyadmin> \n
  Options SymLinksIfOwnerMatch \n
  DirectoryIndex index.php \n

  # Autoriser accès depuis certaines adresses IP / sous-réseau
  #Order deny,allow \n
  #Deny from all \n
  #Allow from 192.168.1.0/24 \n

  <IfModule mod_php.c> \n
    <IfModule mod_mime.c> \n
      AddType application/x-httpd-php .php \n
    </IfModule> \n
    <FilesMatch ".+\.php$"> \n
      SetHandler application/x-httpd-php \n
    </FilesMatch> \n

    php_value include_path . \n
    php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp \n
    
    php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
    
    php_admin_value mbstring.func_overload 0 \n
  </IfModule> \n

</Directory> \n

# Désactiver accès web sur certains dossiers \n
<Directory /usr/share/phpmyadmin/templates> \n
  Require all denied \n
</Directory> \n
<Directory /usr/share/phpmyadmin/libraries> \n
  Require all denied \n
</Directory> \n
<Directory /usr/share/phpmyadmin/setup/lib> \n
  Require all denied \n
</Directory>" | sudo tee /etc/apache2/conf-available/phpmyadmin.conf

# Vérifier si la ligne ServerName existe déjà dans apache2.conf
if grep -q "ServerName 127.0.0.1" /etc/apache2/apache2.conf; then
    echo "La ligne ServerName existe déjà dans apache2.conf."
else
    # Ajouter la ligne ServerName 127.0.0.1 à la fin de apache2.conf
    sudo bash -c "echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf"
    echo "La ligne ServerName a été ajoutée à apache2.conf."
fi


sudo a2enconf phpmyadmin.conf
sudo apachectl configtest
sudo systemctl reload apache2

# Exécuter la commande 'ip a' dans xterm, extraire l'adresse IP et l'utiliser dans le message Zenity
ip_info=$(ip a)
ip_address=$(echo "$ip_info" | awk '/inet / {print $2}')
message="Vous pouvez acceder a phpMyAdmin en saisissant dans un navigateur :
http://$ip_address/pma"

# Afficher le message dans une fenêtre Zenity
echo "$message" | zenity --text-info --title="Info PhpMyAdmin"

# Créer un fichier avec les instructions d'accès à phpMyAdmin
echo "Vous pouvez accéder à phpMyAdmin en saisissant dans un navigateur :
http://votreadresseip(pour inet)/pma" | tee /home/$USER/READ_ME_LICHROD/comment_acceder_a_phpmyadmin

echo "Instructions ajoutées dans le fichier /home/$USER/READ_ME_LICHROD/comment_acceder_a_phpmyadmin."

sudo rm /usr/share/phpmyadmin/setup/ -Rf



