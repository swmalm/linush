#!/bin/bash

art="
┏┓┓┏┏┓┏┳┓┏┓┳┳┓  ┳┳┓┏┓┳┓┏┓┏┓┏┓┳┓  ┏  ┓ ┏┓ ┏┓┏┓┓
┗┓┗┫┗┓ ┃ ┣ ┃┃┃  ┃┃┃┣┫┃┃┣┫┃┓┣ ┣┫  ┃┓┏┃ ┃┫ ┣┓┗┫┃
┗┛┗┛┗┛ ┻ ┗┛┛ ┗  ┛ ┗┛┗┛┗┛┗┗┛┗┛┛┗  ┗┗┛┻•┗┛•┗┛┗┛┛
"
clear

if [ "$EUID" == 0 ]; then
	printf "Please don't run the script with sudo!"
	read -rp "Press any key to exit..."
	exit
fi

if [[ $(uname -r) == *"nobara"* ]]; then
    printf "Nobara uses custom kernels, configs and packages that makes it incompatible with this script.\n"
    printf "Tweaks included in Linush are already set by default.\n\n"
    read -p "Do you still want to continue? (y/n) > " -n 1 -r
    printf "\n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        clear
        printf "Good Luck!\n"
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
	if [ -x "$(command -v apt-get)" ];then
		sudo apt-get install -y $@
	elif [ -x "$(command -v dnf)" ];then
		sudo dnf install -y $@
	elif [ -x "$(command -v zypper)" ];then
		sudo zypper install -y $@
	elif [ -x "$(command -v pacman)" ];then
		sudo pacman -S --noconfirm $@
	else
		printf "FAILED TO INSTALL: Package manager not found. Try manually installing: "$@"">&2;
		read -rp "Press enter to continue..."
	fi
}

read -rp "Welcome to Linush! Press enter to continue..."

print_help(){
    printf "${blue}**************************************${white}\n"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "${blue}--------------------------------------${white}\n\n"

    printf "${green}NETWORK${white}\n"
    printf "${red}ni${white} - Network Information\n\n"

    printf "${green}USER UTILITY${white}\n"
    printf "${red}ua${white} - Create a new user\n"
    printf "${red}ul${white} - List all logged in users\n"
    printf "${red}uv${white} - View users properties\n"
    printf "${red}um${white} - Modify users properties\n"
    printf "${red}ud${white} - Delete a user\n\n"

    printf "${green}GROUP UTILITY${white}\n"
    printf "${red}ga${white} - Create a new group\n"
    printf "${red}gl${white} - List all groups, not system groups\n"
    printf "${red}gv${white} - List all users in a group\n"
    printf "${red}gm${white} - Add/Remove user to/from a group\n"
    printf "${red}gd${white} - Delete group, not system group\n\n"

    printf "${green}FOLDER UTILITY${white}\n"
    printf "${red}fa${white} - Create a folder\n"
    printf "${red}fl${white} - View content of a folder\n"
    printf "${red}fv${white} - View folder properties\n"
    printf "${red}fm${white} - Modify folder properties\n"
    printf "${red}fd${white} - Delete a folder\n\n"

    printf "${green}PACKAGES${white}\n"
    printf "${red}pkg${white} - Install, Update or Remove packages\n"
    printf "${red}fast${white} - Fastfetch\n"
    printf "${red}star${white} - Starship\n"
    printf "${red}game${white} - Gaming Essentials\n\n"

    printf "${green}DISTRO SPECIFIC${white}\n"
    printf "${red}fed${white} - Fedora-based\n"
    printf "${red}arch${white} - Arch-based\n"
    printf "${red}deb${white} - Debian-based\n\n"

    printf "${green}SYSTEM${white}\n"
    printf "${red}firm${white} - Firmware\n"
    printf "${red}flat${white} - Flatpak\n\n"

    printf "${yellow}ex${white} - Exit the program\n"
}

fedora(){
    printf "${blue}**************************************${white}\n"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "${blue}--------------------------------------${white}\n\n"
    printf "${green}FEDORA${white}\n"
    printf "${red}rpm${white} - RPM Fusion\n"
    printf "${red}dnf${white} - DNF Config\n"
    printf "${red}zram${white} - Edit zram swap size\n"
    printf "${red}vmax${white} - Increase vm.max_map_count\n"
    printf "${red}vir${white} - Virtualization\n"
    printf "${red}upg${white} - Full System Upgrade\n"
    printf "${red}nvi${white} - Install NVIDIA Driver and CUDA\n"
}

debian(){
    printf "${blue}**************************************${white}\n"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "${blue}--------------------------------------${white}\n\n"
    printf "${green}DEBIAN${white}\n"
    printf "${red}nvi${white} - Nvidia Driver\n"
    printf "${red}vir${white} - Virtualization\n"
    printf "${red}upt${white} - Full System Upgrade\n"
}


arch(){
    printf "${blue}**************************************${white}\n"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "${blue}--------------------------------------${white}\n\n"
    printf "${green}ARCH${white}\n"
    printf "${red}nvi${white} - Nvidia Driver\n"
    printf "${red}upt${white} - Full System Upgrade\n"
    printf "${red}vir${white} - Virtualization\n\n"
}

sysman_logo(){
    printf "${blue}**************************************${white}\n"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "${blue}--------------------------------------${white}\n"
}

checkUpToDate(){
	clear
}

while true; do

	# Start of loop, clears terminal, prints the header and asks for selection 
    clear
    print_help
	printf "\n"
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
        printf "Quitting...";
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
		packageToInstall $pkg_select
		read -rp "Press enter to continue..."
		;;

	"fast")
		clear
		packageToInstall fastfetch
		read -rp "Press enter to continue..."
		;;

	"star")
		clear
		if [ -x "$(command -v curl)" ];then
			curl -sS https://starship.rs/install.sh | sh
		else
			packageToInstall curl
			curl -sS https://starship.rs/install.sh | sh
		fi
		read -rp "Press enter to continue..."
		;;

	"flat")
		clear
		packageToInstall flatpak
		if [ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ];then
			packageToInstall gnome-software-plugin-flatpak
		elif [ "$XDG_CURRENT_DESKTOP" == *"KDE"* ];then
			packageToInstall plasma-discover-backend-flatpak
		fi
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		printf "${green}Successfully installed Flathub and added Flathub as repository! ${white}\n\n"
		read -rp "Press enter to continue..."
		;;

	"game")
		clear
		printf "Gaming on Linux is a bit different than on Windows and to maximize ease-of-use,\n"
		printf "there are certain packages that are recommended to have installed.\n\n"
		printf "Packages that will be installed:\n"
		printf "Steam: Binary version\n"
		printf "Gamescope: Valve's window manager that can improve support for some games and features like HDR\n"
		printf "MangoHud: FPS counter and hardware monitoring software\n"
		printf "Goverlay: MangoHud configuration tool\n"
		printf "Lutris: Alternative game launcher with integration for platforms like EA App, Ubisoft Connect, Humble Bundle, etc.\n"
		printf "Heroic Games Launcher: Alternative game launcher with very good integration for Epic Games Launcher, GOG Galaxy and Amazon Prime Gaming\n"
		printf "Gear Lever: Utility for handling .appimages like Heroic Games Launcher\n\n"
		read -rp "Do you want to install all the recommended packages? (y/n) > " -n 1 -r
		printf "\n"
		if [ -x "$(command -v flatpak)" ];then
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				packageToInstall steam gamescope mangohud goverlay lutris curl
				mkdir -p "$HOME/AppImages"
				curl -s https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest | grep browser_download_url | grep '.AppImage' | cut -d '"' -f 4 | xargs curl -L -o "$HOME/AppImages/heroic_games_launcher.appimage"
				sudo flatpak install it.mijorus.gearlever -y
				printf "${green}Unlock the AppImage and move it to the app menu.${white}\n"
				flatpak run it.mijorus.gearlever "$HOME/AppImages/heroic_games_launcher.appimage"
				read -rp "Press enter to continue..."
			else
				printf "\n"
				read -rp "Press enter to continue..."
			fi
		else
			printf "Flatpak is not installed on this system. You can use the 'flat' tool to install it and try again.\n\n"
			read -rp "Press enter to continue..."
		fi
		;;
	
	"fed")
		clear
		fedora
		read -rp "Selection > " fed_select;
		printf "\n"
    	case $fed_select in
		"rpm")
			printf "RPM Fusion is a repository with non-free software like proprietary nvidia drivers.\n\n"
			read -p "Do you want to install RPM Fusion? (y/n) > " -n 1 -r # One letter only
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then # Reply is default variable name
				sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
				sudo dnf update @core
			fi
			;;
		"nvi")
			printf "For best performance on Linux, it's best to use the proprietary nvidia driver.\n\n"
			read -p "Do you want to install the nvidia driver? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if dnf repolist | grep rpmfusion-nonfree; then
					sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
				else
					printf "ERROR: RPMFUSION NOT FOUND!\n\n"
					read -rp "Press enter to continue..."
				fi
			fi
			;;
		"zram")
			printf "ZRAM is a modern implementation of the swapfile.\n\n"
			read -p "Do you want to increase your zram size? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				read -rp "Type size in GB for zram (Half of your RAM is a good place to start): " zram_size;
				if [[ "$zram_size" =~ ^[0-9]+$ ]]; then
					sudo sed -i "/zram-size/c\\zram-size = $zram_size * 1024" "/usr/lib/systemd/zram-generator.conf"
				else
					printf "ERROR: INVALID INTEGER! \n\n"
					read -rp "Press enter to continue..."
				fi
			fi
			;;
		"vmax")
			printf "vm.max_map_count is the virtual memory limit on your machine, \n"
			printf "increasing it can help with performance in games like Star Citizen.\n\n"
			read -p "Do you want to increase your virtual memory to a recommended limit? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo sysctl -w vm.max_map_count=16777216
			fi
			;;
		"dnf")
			printf "By default, DNF has pretty conservative settings for max_parallel_downloads and using the fastest mirror.\n"
			printf "Adding more capacity and allowing fastest mirror can speed up package handling. \n\n"
			read -p "Do you want to increase max_parallel_download and make sure to always use the fastest mirror available? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    				sudo sed -i 's/^max_parallel_downloads=.*/max_parallel_downloads=10/' /etc/dnf/dnf.conf
				else
    				sudo printf "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
				fi
				if grep -q "fastestmirror" /etc/dnf/dnf.conf; then
    				sudo sed -i 's/^fastestmirror=.*/fastestmirror=true/' /etc/dnf/dnf.conf
				else
    				sudo printf "fastestmirror=true" >> /etc/dnf/dnf.conf
				fi
				printf "Increased max_parallel_download to 10 and set fastestmirror to true. \n"
			fi
			;;
		"vir")
			printf "Virtualization on Fedora is available through the QEMU emulator that works with KVM to create and manage your VMs.\n"
			printf "Libvirt is the service that will be set up to handle this.\n\n"
			read -p "Do you want to enable virtualization support and have the current user be able to manage the VMs? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo dnf install @virtualization
				sudo sed -i 's/^#unix_sock_group = "libvirt".*/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
				sudo sed -i 's/^#unix_sock_rw_perms = "0770".*/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
				sudo systemctl start libvirtd
				sudo systemctl enable libvirtd
				sudo usermod -a -G libvirt $(whoami)
			fi
			;;
		"upg")
			printf "Keeping your system up to date is very important for security purposes.\n"
			read -p "Would you like to check for updates on all your installed packages? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo dnf update -y && dnf upgrade -y
				if [ -x "$(command -v flatpak)" ]; then
					sudo flatpak update -y
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
		read -rp "Selection > " arch_select;
		printf "\n"
    	case $arch_select in
		"nvi")
			checkUpToDate
			read -p "Do you want to check for system compatibility and install the nvidia driver? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if [[ $(lspci -k | grep VGA | grep NVIDIA) && $(cat /etc/*-release) =~ "Arch" ]]; then
					gpu_model=$(lspci -k | grep VGA | grep NVIDIA | sed -n 's/.*Corporation\s*\([A-Za-z][A-Za-z]\).*/\1/p')
					if [[ "$gpu_model" =~ (TU|GA|AD)$ ]]; then
						cpu_model=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ':' -f 2 | sed -E 's/.*i[3579]-([0-9]{4}).*/\1/' | cut -c1-2)
						kernel=$(pacman -Q | grep -E '^linux(| |-lts)[^-headers]' | cut -d ' ' -f 1)
						header="${kernel}-headers"
						if [[ "$kernel" = "linux" ]]; then
							packageToInstall nvidia-open nvidia-utils nvidia-settings lib32-nvidia-utils "$header"
							printf "options nvidia_drm modeset=1\noptions nvidia_drm fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null
							sudo sed -i 's/^MODULES=(.*)/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
							sudo sed -i 's/\(HOOKS=.*\)\<kms\>\(.*\)/\1\2/' /etc/mkinitcpio.conf
							printf "options nvidia NVreg_PreserveVideoMemoryAllocations=1\noptions nvidia NVreg_TemporaryFilePath=/var/tmp" | sudo tee -a /etc/modprobe.d/nvidia.conf > /dev/null
							sudo mkinitcpio -P
							sudo systemctl enable nvidia-suspend
							sudo systemctl enable nvidia-hibernate
							sudo systemctl enable nvidia-resume
						elif [[ "$kernel" = "linux-lts" ]]; then
							packageToInstall nvidia-open-lts nvidia-utils nvidia-settings "$header"
							printf "options nvidia_drm modeset=1\noptions nvidia_drm fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null
							sudo sed -i 's/^MODULES=(.*)/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
							sudo sed -i 's/\(HOOKS=.*\)\<kms\>\(.*\)/\1\2/' /etc/mkinitcpio.conf
							printf "options nvidia NVreg_PreserveVideoMemoryAllocations=1\noptions nvidia NVreg_TemporaryFilePath=/var/tmp" | sudo tee -a /etc/modprobe.d/nvidia.conf > /dev/null
							sudo mkinitcpio -P
							sudo systemctl enable nvidia-suspend
							sudo systemctl enable nvidia-hibernate
							sudo systemctl enable nvidia-resume
						else
							printf "Unsupported Kernel."
							return
						fi
						if [[ "$cpu_model" -ge 11 ]]; then
							if [[ ! $(grep -w ibt=off /etc/default/grub) ]]; then
								sudo sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 ibt=off"/' /etc/default/grub
								sudo grub-mkconfig -o /boot/grub/grub.cfg
							else
								printf "Kernel is already set up."
							fi
						fi
						read -p "Do you want to reboot now to reload the new driver? (y/n) > " -n 1 -r
						printf "\n"
						if [[ $REPLY =~ ^[Yy]$ ]]; then
							sudo reboot
						fi
					else
						printf "Unsupported hardware or Linux distribution."
					fi
				else
					printf "NVIDIA Hardware not found."
				fi
			fi
		;;
		"upt")
		;;
		"vir")
		;;
		esac
		read -rp "Press enter to continue..."
		;;

	"firm")
		clear
		;;

	# If the selection is invalid
	*)
        printf "ERROR... [Invalid Selection: '$selection'] \n\n"
		read -rp "Press enter to continue..."
        ;;		
esac

done