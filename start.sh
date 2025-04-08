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

print_help(){
	echo -e "${blue}**************************************${white}"
	echo "       SYSTEM MANAGER (v0.1-rewrite)          "
	echo -e "${blue}--------------------------------------${white}"
	echo ""
	echo -e "${green}NETWORK${white}"
	echo -e "${red}ni${white} - Network Information"
	echo ""
	echo -e "${green}USER UTILITY${white}"
	echo -e "${red}ua${white} - Create a new user"
	echo -e "${red}ul${white} - List all logged in users"
	echo -e "${red}uv${white} - View users properties"
	echo -e "${red}um${white} - Modify users properties"
	echo -e "${red}ud${white} - Delete a user"
	echo ""
	echo -e "${green}GROUP UTILITY${white}"
	echo -e "${red}ga${white} - Create a new group"
	echo -e "${red}gl${white} - List all groups, not system groups"
	echo -e "${red}gv${white} - List all users in a group"
	echo -e "${red}gm${white} - Add/Remove user to/from a group"
	echo -e "${red}gd${white} - Delete group, not system group"
	echo ""
	echo -e "${green}FOLDER UTILITY${white}"
	echo -e "${red}fa${white} - Create a folder"
	echo -e "${red}fl${white} - View content of a folder"
	echo -e "${red}fv${white} - View folder properties"
	echo -e "${red}fm${white} - Modify folder properties"
	echo -e "${red}fd${white} - Delete a folder"
	echo ""
	echo -e "${green}OTHER${white}"
	echo -e "${red}pkg${white} - Install, Update or Remove packages"
	echo -e ""
	echo -e "${yellow}ex${white} - Exit the program"
}

sysman_logo(){
	echo -e "${blue}**************************************${white}"
	echo "       SYSTEM MANAGER (v0.1-rewrite)          "
	echo -e "${blue}--------------------------------------${white}"
}

while true; do

	# Start of loop, clears terminal, prints the header and asks for selection 
    clear
    print_help
	echo ""
    read -rp "Selection > " selection;
    case $selection in

	# Network Info
    "ni")
		clear
        read -rp "Press enter to continue..."
        ;;

	# Exit program
    "ex")
		clear
        echo "Quitting...";
        exit 0
        ;;

	# Create user
	"ua")
		clear
		read -rp "Press enter to continue..."
		;;

	# Lists all users, not including system users
	"ul")
		clear
		read -rp "Press enter to continue..."
		;;

	# View user properties
	"uv")
		clear
		read -rp "Press enter to continue..."
		;;
		
	# Delete user
	"ud")
		clear
		read -rp "Press enter to continue..."
		;;
		
	# Modify user properties
	"um")
		clear
		read -rp "Press enter to continue..."
		;;
		
	# Create group
	"ga")
		clear
		read -rp "Press enter to continue..."
		;;
		
	# Lists all user groups
	"gl")
		clear
		read -rp "Press enter to continue..."
		;;

	# View specifed group
	"gv")
		clear
		read -rp "Press enter to continue..."
		;;
	
	# Add/Remove user from group
	"gm")
		clear
		read -rp "Press enter to continue..."
		;;
	
	# Delete group
	"gd")
		clear
		read -rp "Press enter to continue..."
		;;
	
	# Create folder
	"fa")
		clear
		read -rp "Press enter to continue..."
		;;

	# View content of folder
	"fl")
		clear
		read -rp "Press enter to continue..."
		;;

	# View folder properties
	"fv")
		clear
		read -rp "Press enter to continue..."
		;;

	# Modify folder properties
	"fm")
		clear
		read -rp "Press enter to continue..."
		;;
		
	# Delete folder
	"fd")
		clear
		read -rp "Press enter to continue..."
		;;

	"pkg")
		clear
		read -rp "Press enter to continue..."
		;;

	# If the selection is invalid
	*)
        echo "ERROR... [Invalid Selection: '$selection']"
        echo ""
		read -rp "Press enter to continue..."
        ;;		
esac

done


