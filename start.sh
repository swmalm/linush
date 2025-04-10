#!/bin/sh

# Future Features: "here's how you can do it manually if the config is different on your pc", "multiple options for parts of commands like only installing steam and not gamescope"

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

if [[ $(uname -r) == *"nobara"* ]]; then
	echo -e "Nobara uses custom kernels, configs and packages that makes it incompatible with this script.\nTweaks included in Linush are already set by default."
	echo ""
	read -ep "Do you still want to continue? (y/n) > " -n 1 -r
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		clear
		echo "Good Luck!"
	else
		read -rp "Press any key to exit..."
		exit
	fi
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
		apt-get install "${packagesNeeded[@]}"

	elif [ -x "$(command -v dnf)" ];
	then
		dnf install "${packagesNeeded[@]}"

	elif [ -x "$(command -v zypper)" ];
	then
		zypper install "${packagesNeeded[@]}"

	elif [ -x "$(command -v pacman)" ];
	then
		pacman -S "${packagesNeeded[@]}"

	else
		echo "FAILED TO INSTALL: Package manager not found. Try manually installing: "${packagesNeeded[@]}"">&2;
	fi
}

read -rp "Welcome to Linush! Press enter to continue..."

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
	echo -e "${red}game${white} - Gaming Essentials"
	echo -e ""
	echo -e "${green}DISTRO SPECIFIC${white}"
	echo -e "${red}fed${white} - Fedora-based"
	echo -e "${red}arch${white} - Arch-based"
	echo -e "${red}deb${white} - Debian-based"
	echo -e ""	
	echo -e "${green}SYSTEM${white}"
	echo -e "${red}firm${white} - Firmware"
	echo -e "${red}flat${white} - Flatpak"
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

	"flat")
		clear
		;;

	"game")
		clear
		echo -e "Gaming on Linux is a bit different than on Windows and to maximize ease-of-use,\nthere are certain packages that are recommended to have installed."
		echo -e ""
		echo -e "Packages that will be installed:\nSteam: Binary version"
		echo -e "Gamescope: Valve's window manager that can improve support for some games and features like HDR\nMangoHud: FPS counter and hardware monitoring software"
		echo -e "Goverlay: MangoHud configuration tool\nLutris: Alternative game launcher with integration for platforms like EA App, Ubisoft Connect, Humble Bundle, etc."
		echo -e "Heroic Games Launcher: Alternative game launcher with very good integration for Epic Games Launcher, GOG Galaxy and Amazon Prime Gaming"
		echo -e "Gear Lever: Utility for handling .appimages like Heroic Games Launcher"
		echo ""
		read -p "Do you want to install all the recommended packages? (y/n) > " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			pkgs = "steam gamescope mangohud goverlay lutris"
			packageToInstall "$pkgs"
			curl -s https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest | grep browser_download_url | grep '.AppImage' | cut -d '"' -f 4 | xargs curl -L -o ~/AppImages/heroic_games_launcher.appimage
			flatpak install it.mijorus.gearlever -y
			flatpak run it.mijorus.gearlever --integrate -y ~/AppImages/heroic_games_launcher.appimage
			read -rp "Press enter to continue..."
		else
			echo ""
		fi
		;;
	
	"fed")
		clear
		fedora
		read -rp "Selection > " fed_select;
    	case $fed_select in
		"rpm")
			echo "RPM Fusion is a repository with non-free software like proprietary nvidia drivers."
			read -p "Do you want to install RPM Fusion? (y/n) > " -n 1 -r # One letter only
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then # Reply is default variable name
				dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
				dnf update @core
			fi
			;;
		"nvi")
			echo "For best performance on Linux, it's best to use the proprietary nvidia driver."
			read -p "Do you want to install the nvidia driver? (y/n) > " -n 1 -r
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if dnf repolist | grep rpmfusion-nonfree; then
					dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
				else
					echo "ERROR: RPMFUSION NOT FOUND!"
				fi
			fi
			;;
		"zram")
			echo "ZRAM is a modern implementation of the swapfile."
			read -p "Do you want to increase your zram size? (y/n) > " -n 1 -r
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				read -rp "Type size in GB for zram (Half of your RAM is a good place to start): " zram_size;
				if [[ "$zram_size" =~ ^[0-9]+$ ]]; then
					sed -i "/zram-size/c\\zram-size = $zram_size * 1024" "/usr/lib/systemd/zram-generator.conf"
				else
					echo "ERROR: INVALID INTEGER!"
				fi
			fi
			;;
		"vmax")
			echo -e "vm.max_map_count is the virtual memory limit on your machine, \nincreasing it can help with performance in games like Star Citizen."
			echo ""
			read -p "Do you want to increase your virtual memory to a recommended limit? (y/n) > " -n 1 -r
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sysctl -w vm.max_map_count=16777216
			fi
			;;
		"dnf")
			echo ""
			echo -e "By default, DNF has pretty conservative settings for max_parallel_downloads and using the fastest mirror.\nAdding more capacity and allowing fastest mirror can speed up package handling."
			echo ""
			read -ep "Do you want to increase max_parallel_download and make sure to always use the fastest mirror available? (y/n) > " -n 1 -r
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    				sed -i 's/^max_parallel_downloads=.*/max_parallel_downloads=10/' /etc/dnf/dnf.conf
				else
    				echo -e "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
				fi
				if grep -q "fastestmirror" /etc/dnf/dnf.conf; then
    				sed -i 's/^fastestmirror=.*/fastestmirror=true/' /etc/dnf/dnf.conf
				else
    				echo -e "fastestmirror=true" >> /etc/dnf/dnf.conf
				fi
				echo -e "Increased max_parallel_download to 10 and set fastestmirror to true."
				echo ""
			fi
			;;
		"vir")
			echo ""
			echo -e "Virtualization on Fedora is available through the QEMU emulator that works with KVM to create and manage your VMs.\nLibvirt is the service that will be set up to handle this."
			echo ""
			read -ep "Do you want to enable virtualization support and have the current user be able to manage the VMs? (y/n) > " -n 1 -r
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				dnf install @virtualization
				sed -i 's/^#unix_sock_group = "libvirt".*/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
				sed -i 's/^#unix_sock_rw_perms = "0770".*/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
				systemctl start libvirtd
				systemctl enable libvirtd
				usermod -a -G libvirt $(whoami)
			fi
			;;
		"upg")
			echo ""
			echo -e "Keeping your system up to date is very important for security purposes."
			echo ""
			read -ep "Would you like to check for updates on all your installed packages, including flatpaks? (y/n) > " -n 1 -r
			echo ""
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				dnf update -y && dnf upgrade -y
				if [ -x "$(command -v flatpak)" ]; then
					flatpak update -y
				fi
			fi
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

	"firm")
		clear
		;;

	# If the selection is invalid
	*)
        echo "ERROR... [Invalid Selection: '$selection']"
        echo ""
		read -rp "Press enter to continue..."
        ;;		
esac

done