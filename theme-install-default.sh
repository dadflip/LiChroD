#!/bin/bash

sudo apt-get install -y sassc libglib2.0-dev libgdk-pixbuf2.0-dev libxml2-utils
sudo apt install -y numix-gtk-theme

gsettings set org.gnome.desktop.interface gtk-theme "Numix"
gsettings set org.gnome.desktop.wm.preferences theme "Numix"

xfconf-query -c xsettings -p /Net/ThemeName -s "Numix"
xfconf-query -c xfwm4 -p /general/theme -s "Numix"
