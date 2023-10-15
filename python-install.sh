#!/bin/bash

# Chemin complet du dossier des binaires
BINARIES_DIRECTORY="/usr/bin"
OPT_DIRECTORY="/opt"
TMP_DIRECTORY="/tmp"

# Afficher une fenêtre Zenity pour saisir la version de Python à installer
vers=$(zenity --entry --title="Installation de Python" --text="Entrez une version de Python (format: X.X.X) - pour le fonctionnement de MyApp, la version 3.10.12 est conseillee ! :")

# Vérifier si la version entrée est valide
if [[ $vers =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Afficher une fenêtre Zenity pour afficher le processus d'installation
    (
    echo "Installation en cours..."
    sudo apt update
    sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev pip libsqlite3-dev wget libbz2-dev
    cd $TMP_DIRECTORY
    wget https://www.python.org/ftp/python/$vers/Python-$vers.tgz
    tar -xvf Python-$vers.tgz
    cd Python-$vers
    sudo ./configure --enable-optimizations --prefix=$OPT_DIRECTORY/python-$vers
    sudo make -j$(nproc)
    sudo make altinstall
    echo "Installation terminee."
    ) | zenity --text-info --title="Processus d'installation"
    
    # Créer les liens symboliques vers la version installée de Python
    sudo ln -s $OPT_DIRECTORY/python-$vers/bin/python$vers /usr/local/bin/python$vers
    sudo ln -s $OPT_DIRECTORY/python-$vers/bin/pip$vers /usr/local/bin/pip$vers
    sudo ln -s /usr/local/bin/python$vers /usr/local/bin/python
    sudo ln -s /usr/local/bin/pip$vers /usr/local/bin/pip

    # Afficher un message de fin avec Zenity
    zenity --info --text="Python $vers a ete installe avec succes."
else
    # Affiche un message d'erreur si la version entrée par l'utilisateur est invalide
    zenity --error --text="La version entree est invalide. Veuillez entrer une version valide (format: X.X.X)."
fi

# Afficher une fenêtre Zenity pour l'installation des bibliothèques
zenity --info --text="Selectionnez les bibliotheques à installer :"

# Bibliothèques avec cases à cocher
install_pygame=$(zenity --list --title="Installation de bibliotheques" --checklist \
                        --column="Sélection" --column="Bibliotheque" --column="Description" \
                        TRUE "Pygame" "Bibliotheque pour le developpement de jeux" \
                        TRUE "Pyaudio" "Bibliotheque pour le traitement audio" \
                        TRUE "SpeechRecognition" "Reconnaissance vocale" \
                        TRUE "Terminator et Xterm" "Emulateurs de terminal" \
                        TRUE "python3-tk" "Interface graphique Tkinter" \
                        TRUE "espeak-ng" "Synthese vocale" \
                        TRUE "Playsound" "Gestion des sons" \
                        TRUE "Pyttsx3" "Synthese vocale en texte" \
                        TRUE "Py_espeak_ng" "Synthese vocale en texte (espeak-ng)" --separator="|")

IFS="|"
choices=($install_pygame)
for choice in "${choices[@]}"; do
    case $choice in
        "Pygame") 
            sudo apt update
            sudo apt install -y python3-pygame
            ;;
        "Pyaudio")
            sudo apt update
            sudo apt install -y python3-pyaudio
            ;;
        "SpeechRecognition")
            pip3 install SpeechRecognition
            ;;
        "Terminator et Xterm")
            sudo apt update
            sudo apt install -y terminator xterm
            ;;
        "python3-tk")
            sudo apt install -y python3-tk
            ;;
        "espeak-ng")
            sudo apt install -y espeak-ng espeak
            ;;
        "Playsound")
            sudo cp -r "$OPT_DIRECTORY/myapp/modules/playsound.py" "/usr/lib/python3.9/playsound.py"
            sudo cp -r "$OPT_DIRECTORY/myapp/modules/playsound-1.3.0.dist-info/" "/usr/lib/python3.9/playsound-1.3.0.dist-info"
            ;;
        "Pyttsx3")
            sudo cp -r "$OPT_DIRECTORY/myapp/modules/pyttsx3/" "/usr/lib/python3.9/pyttsx3"
            sudo cp -r "$OPT_DIRECTORY/myapp/modules/pyttsx3-2.90.dist-info/" "/usr/lib/python3.9/pyttsx3-2.90.dist-info"
            ;;
        "Py_espeak_ng")
            sudo cp -r "$OPT_DIRECTORY/myapp/modules/espeakng/" "/usr/lib/python3.9/espeakng"
            sudo cp -r "$OPT_DIRECTORY/myapp/modules/py_espeak_ng-0.1.8.dist-info/" "/usr/lib/python3.9/py_espeak_ng-0.1.8.dist-info"
            ;;
    esac
done

# Copie des fichiers et dossiers avec `sudo`
sudo cp -r "$OPT_DIRECTORY/myapp/modules/playsound.py" "/usr/lib/python3.9/playsound.py"
sudo cp -r "$OPT_DIRECTORY/myapp/modules/playsound-1.3.0.dist-info/" "/usr/lib/python3.9/playsound-1.3.0.dist-info"
sudo cp -r "$OPT_DIRECTORY/myapp/modules/pyttsx3/" "/usr/lib/python3.9/pyttsx3"
sudo cp -r "$OPT_DIRECTORY/myapp/modules/pyttsx3-2.90.dist-info/" "/usr/lib/python3.9/pyttsx3-2.90.dist-info"
sudo cp -r "$OPT_DIRECTORY/myapp/modules/espeakng/" "/usr/lib/python3.9/espeakng"
sudo cp -r "$OPT_DIRECTORY/myapp/modules/py_espeak_ng-0.1.8.dist-info/" "/usr/lib/python3.9/py_espeak_ng-0.1.8.dist-info"

# Donner les permissions en lecture et écriture avec `chmod`
sudo chmod -R a+rw /usr/lib/python3.9/playsound.py
sudo chmod -R a+rw /usr/lib/python3.9/playsound-1.3.0.dist-info
sudo chmod -R a+rw /usr/lib/python3.9/pyttsx3
sudo chmod -R a+rw /usr/lib/python3.9/pyttsx3-2.90.dist-info
sudo chmod -R a+rw /usr/lib/python3.9/espeakng
sudo chmod -R a+rw /usr/lib/python3.9/py_espeak_ng-0.1.8.dist-info


# Afficher un message de fin
zenity --info --text="Le script d'installation est termine."
