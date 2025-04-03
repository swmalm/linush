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

grn='\e[0;32m'
blu='\e[0;34m'
wht='\e[0;37m'
red='\e[0;31m'
yel='\e[1;33m'