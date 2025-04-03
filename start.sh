#!/bin/sh

art="
┏┓┓┏┏┓┏┳┓┏┓┳┳┓  ┳┳┓┏┓┳┓┏┓┏┓┏┓┳┓  ┏  ┓ ┏┓ ┏┓┏┓┓
┗┓┗┫┗┓ ┃ ┣ ┃┃┃  ┃┃┃┣┫┃┃┣┫┃┓┣ ┣┫  ┃┓┏┃ ┃┫ ┣┓┗┫┃
┗┛┗┛┗┛ ┻ ┗┛┛ ┗  ┛ ┗┛┗┛┗┛┗┗┛┗┛┛┗  ┗┗┛┻•┗┛•┗┛┗┛┛
"
clear

if [ "$EUID" -ne 0 ]; then
	echo "Please run the script with sudo!"
	read -rp "Press any key to exit..."
	exit
fi

IFS=$'\n'
for line in $art; do
    echo "$line"
    sleep 0.2
done

green='\e[0;32m'
blue='\e[0;34m'
white='\e[0;37m'
red='\e[0;31m'
yellow='\e[1;33m'

read -rp "Press any key to continue..."