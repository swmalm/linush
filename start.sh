#!/bin/sh

#thinking of like check before installing that explains shit
#also having like a "here's how you can do it manually if the config is different on your pc"

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

packageToInstall(){
	packagesNeeded="$1"
	if [ -x "$(command -v apt-get)" ];
	then
		sudo apt-get install "${packagesNeeded[@]}"

	elif [ -x "$(command -v dnf)" ];
	then
		sudo dnf install "${packagesNeeded[@]}"

	elif [ -x "$(command -v zypper)" ];
	then
		sudo zypper install "${packagesNeeded[@]}"

	elif [ -x "$(command -v pacman)" ];
	then
		sudo pacman -S "${packagesNeeded[@]}"

	else
		echo "FAILED TO INSTALL: Package manager not found. Try manually installing: "${packagesNeeded[@]}"">&2;
	fi
}

read -rp "Press any key to continue..."

print_help(){
	echo -e "${blue}**************************************${white}"
	echo "     SYSTEM MANAGER (v0.1-rewrite)     "
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
	echo -e "${green}PACKAGES${white}"
	echo -e "${red}pkg${white} - Install, Update or Remove packages"
	echo -e "${red}fast${white} - Fastfetch"
	echo -e "${red}star${white} - Starship"
	echo -e ""
	echo -e "${green}DISTROS${white}"
	echo -e "${red}fed${white} - Fedora-based"
	echo -e "${red}arch${white} - Arch-based"
	echo -e "${red}deb${white} - Debian-based"
	echo -e ""
	echo -e "${yellow}ex${white} - Exit the program"
}

fedora(){
	echo -e "${blue}**************************************${white}"
	echo "     SYSTEM MANAGER (v0.1-rewrite)     "
	echo -e "${blue}--------------------------------------${white}"
	echo -e "${green}FEDORA${white}"
	echo -e ""
	echo -e "${red}rpm${white} - RPM Fusion"
	echo -e "${red}dnf${white} - DNF Config"
	echo -e "${red}zram${white} - Edit zram swap size"
	echo -e "${red}vmax${white} - Increase vm.max_map_count"
	echo -e "${red}vir${white} - Virtualization"
	echo -e "${red}upg${white} - Full System Upgrade"
	echo -e "${red}nvi${white} - Install NVIDIA Driver and CUDA"
}

debian(){
	echo -e "${blue}**************************************${white}"
	echo "     SYSTEM MANAGER (v0.1-rewrite)     "
	echo -e "${blue}--------------------------------------${white}"
	echo -e ""
	echo -e "${green}DEBIAN${white}"
	echo -e "${red}rpm${white} - Nvidia Driver"
	echo -e "${red}vir${white} - Virtualization"
	echo -e "${red}upt${white} - Full System Upgrade"
}

arch(){
	echo -e "${blue}**************************************${white}"
	echo "     SYSTEM MANAGER (v0.1-rewrite)     "
	echo -e "${blue}--------------------------------------${white}"
	echo -e ""
	echo -e "${green}ARCH${white}"
	echo -e "${red}rpm${white} - Nvidia Driver"
	echo -e "${red}upt${white} - Full System Upgrade"
	echo -e "${red}vir${white} - Virtualization"
}

sysman_logo(){
	echo -e "${blue}**************************************${white}"
	echo "     SYSTEM MANAGER (v0.1-rewrite)     "
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
		read -rp "Package to install: " pkg_select;
		packageToInstall "$pkg_select"
		read -rp "Press enter to continue..."
		;;

	"fast")
		clear
		packageToInstall "fastfetch"
		read -rp "Press enter to continue..."
		;;

	"star")
		clear
		curl -sS https://starship.rs/install.sh | sh
		read -rp "Press enter to continue..."
		;;
	
	"fed")
		clear
		fedora
		read -rp "Selection > " fed_select;
    	case $fed_select in
		"rpm")
			sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
			sudo dnf update @core
			;;
		"nvi")
			sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
			;;
		esac
		read -rp "Press enter to continue..."
		;;

	"deb")
		clear
		debian
		read -rp "Press enter to continue..."
		;;

	"arch")
		clear
		arch
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


