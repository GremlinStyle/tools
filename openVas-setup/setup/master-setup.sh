#!/bin/bash

#Creating user for next steps
sudo bash $script/pre-setup.sh

#Start installation of openvas (Debian) source: https://greenbone.github.io/docs/latest/22.4/source-build/index.html
#PS: Followning script (install-setup.sh) is just copy pasted from source
#IMPORTANT USER AND PASSWORD are here set
#install-stup.sh Line 299-300
sudo bash $scrip/install-setup.sh

#Create Services
#IMPORTANT 
sudo bash service-setup.sh
