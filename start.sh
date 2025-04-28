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

green='\033[0;32m'
blue='\033[0;34m'
white='\033[0;37m'
red='\033[0;31m'
yellow='\033[1;33m'

packageToInstall(){
	if [ -x "$(command -v apt-get)" ];then
		sudo apt-get install -y "$@"
	elif [ -x "$(command -v dnf)" ];then
		sudo dnf install -y "$@"
	elif [ -x "$(command -v zypper)" ];then
		sudo zypper install -y "$@"
	elif [ -x "$(command -v pacman)" ];then
		sudo pacman -S --noconfirm "$@"
	else
		printf "FAILED TO INSTALL: Package manager not found. Try manually installing: %s" "$@"
		read -rp "Press enter to continue..."
	fi
}

read -rp "Welcome to Linush! Press enter to continue..."

print_help(){
    printf "%b**************************************%b\n" "$blue" "$white"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "%b--------------------------------------%b\n\n" "$blue" "$white"

    printf "%bNETWORK%b\n" "$green" "$white"
    printf "%bni%b - Network Information\n\n" "$red" "$white"

    printf "%bUSER UTILITY%b\n"  "$green" "$white"
    printf "%bua%b - Create a new user\n" "$red" "$white"
    printf "%bul%b - List all logged in users\n" "$red" "$white"
    printf "%buv%b - View users properties\n" "$red" "$white"
    printf "%bum%b - Modify users properties\n" "$red" "$white"
    printf "%bud%b - Delete a user\n\n" "$red" "$white"

    printf "%bGROUP UTILITY%b\n" "$green" "$white"
    printf "%bga%b - Create a new group\n" "$red" "$white"
    printf "%bgl%b - List all groups, not system groups\n" "$red" "$white"
    printf "%bgv%b - List all users in a group\n" "$red" "$white"
    printf "%bgm%b - Add/Remove user to/from a group\n" "$red" "$white"
    printf "%bgd%b - Delete group, not system group\n\n" "$red" "$white"

    printf "%bFOLDER UTILITY%b\n" "$green" "$white"
    printf "%bfa%b - Create a folder\n" "$red" "$white"
    printf "%bfl%b - View content of a folder\n" "$red" "$white"
    printf "%bfv%b - View folder properties\n" "$red" "$white"
    printf "%bfm%b - Modify folder properties\n" "$red" "$white"
    printf "%bfd%b - Delete a folder\n\n" "$red" "$white"

    printf "%bPACKAGES%b\n" "$green" "$white"
    printf "%bpkg%b - Install, Update or Remove packages\n" "$red" "$white"
    printf "%bfast%b - Fastfetch\n" "$red" "$white"
    printf "%bstar%b - Starship\n" "$red" "$white"
    printf "%bgame%b - Gaming Essentials\n\n" "$red" "$white"

    printf "%bDISTRO SPECIFIC%b\n" "$green" "$white"
    printf "%bfed%b - Fedora-based\n" "$red" "$white"
    printf "%barch%b - Arch-based\n" "$red" "$white"
    printf "%bdeb%b - Debian-based\n\n" "$red" "$white"

    printf "%bSYSTEM%b\n" "$green" "$white"
    printf "%bfirm%b - Firmware\n" "$red" "$white"
    printf "%bflat%b - Flatpak\n\n" "$red" "$white"

    printf "%bex%b - Exit the program\n" "$yellow" "$white"
}

fedora(){
    printf "%b**************************************%b\n" "$blue" "$white"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "%b--------------------------------------%b\n\n" "$blue" "$white"
    printf "%bFEDORA%b\n" "$green" "$white"
    printf "%brpm%b - RPM Fusion\n" "$red" "$white"
    printf "%bdnf%b - DNF Config\n" "$red" "$white"
    printf "%bzram%b - Edit zram swap size\n" "$red" "$white"
    printf "%bvmax%b - Increase vm.max_map_count\n" "$red" "$white"
    printf "%bvir%b - Virtualization\n" "$red" "$white"
    printf "%bupg%b - Full System Upgrade\n" "$red" "$white"
    printf "%bnvi%b - Install NVIDIA Driver and CUDA\n\n" "$red" "$white"
}

debian(){
    printf "%b**************************************%b\n" "$blue" "$white"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "%b--------------------------------------%b\n\n" "$blue" "$white"
    printf "%bDEBIAN%b\n" "$green" "$white"
    printf "%bnvi%b - Nvidia Driver\n" "$red" "$white"
    printf "%bvir%b - Virtualization\n" "$red" "$white"
    printf "%bupt%b - Full System Upgrade\n\n" "$red" "$white"
}


arch(){
    printf "%b**************************************%b\n" "$blue" "$white"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "%b--------------------------------------%b\n\n" "$blue" "$white"
    printf "%bARCH%b\n" "$green" "$white"
    printf "%bnvi%b - Nvidia Driver\n" "$red" "$white"
    printf "%bupt%b - Full System Upgrade\n" "$red" "$white"
    printf "%bvir%b - Virtualization\n\n" "$red" "$white"
}

sysman_logo(){
    printf "%b**************************************%b\n" "$blue" "$white"
    printf "     SYSTEM MANAGER (v0.1-rewrite)     \n"
    printf "%b--------------------------------------%b\n" "$blue" "$white"
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
		sysman_logo
		printf "%b	 NETWORK INFORMATION		%b\n\n" "$yellow" "$white"
		printf "%bHostname: %b%b\n\n" "$blue" "$white" "$(hostname)"
		for interfaces in $(ip -br addr show | grep -v 'lo' | awk '{print $1}'); do # Loops each interface and grabs ips, mac and status with checks for up/down and not found.
			printf "%bInterface: %b%b\n" "$green" "$white" "$interfaces"
			if [[ "$(ip addr show "$interfaces" | grep 'inet' | grep -v ":" | awk '{print $2}')" ]];then
				printf "%bIP Address:%b $(ip addr show "$interfaces" | grep 'inet' | grep -v ":" | awk '{print $2}' | cut -d "/" -f 1)\n" "$green" "$white"
			else
				printf "%bIP Address:%b <Not Found>%b\n" "$green" "$red" "$white"
			fi
			if [[ "$(ip r | grep default | grep "$interfaces" | awk '{print $3}')" ]];then
				printf "%bGateway:%b $(ip r | grep default | grep "$interfaces" | awk '{print $3}')\n" "$green" "$white"
			else
				printf "%bGateway:%b <Not Found>%b\n" "$green" "$red" "$white"
			fi
			printf "%bMAC:%b $(ip addr show "$interfaces" | grep 'link/' | awk '{print $2}')\n" "$green" "$white"
			if [[ "$(ip link show "$interfaces" | awk '{print $9}')" == "UP" ]];then
				printf "Status: %b$(ip link show "$interfaces" | awk '{print $9}')%b\n\n" "$green" "$white"
			else
				printf "Status: %b$(ip link show "$interfaces" | awk '{print $9}')%b\n\n" "$red" "$white"
			fi
		done
        read -rp "Press enter to continue..."
        ;;

	# Exit program
    "ex"|"exit")
		clear
        printf "Quitting...";
        exit 0
        ;;

	# Create user
	"ua")
		clear
		sysman_logo
		printf "%b	   CREATE NEW USER		%b\n\n" "$green" "$white"
		read -rp "Enter the username: " usern

		if ! echo "$usern" | grep '^[a-zA-Z]*$' > /dev/null; then
			printf "%bERROR: USERNAME CAN NOT CONTAIN SPACES OR NUMBERS.%b" "$red" "$white"
		else
			read -rsp "Enter the password: " passw
			printf "\n"
			read -rsp "Enter the password again: " passw_check
			printf "\n"
			if [ "$passw" != "$passw_check" ];then
				printf "\n%bERROR: NOT MATCHING PASSWORDS!%b\n\n" "$red" "$white"
			else
				sudo useradd -m "$usern" -g users -s /bin/bash
				echo "$usern:$passw" | sudo chpasswd
				printf "\n%bUser%b: %b%b%b was created successfully!\n\n" "$green" "$white" "$blue" "$usern" "$white"  
			fi
		fi
		read -rp "Press enter to continue..."
		;;

	# Lists all users, not including system users
	"ul")
		clear
		sysman_logo
		printf "%b	   	USERS		%b\n\n" "$green" "$white"
		printf "Users:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)%b \n\n" "$blue" "$white"
		read -rp "Press enter to continue..."
		;;

	# View user properties
	"uv")
		clear
		sysman_logo
		printf "%b	   USER PROPERTIES		%b\n\n" "$green" "$white"
		printf "Users:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)%b \n\n" "$blue" "$white"
		read -rp "Enter user: " usern
		printf "\n"
		if [ "$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)" == "$usern" ];then
			printf "User ID: %b$(grep -w "^$usern" /etc/passwd | awk -F ":" '{print $3}')%b\n" "$yellow" "$white"
			printf "Group ID: %b$(grep -w "^$usern" /etc/passwd | awk -F ":" '{print $4}')%b\n" "$yellow" "$white"
			printf "Comment: %b$(grep -w "^$usern" /etc/passwd | awk -F ":" '{print $5}')%b\n" "$yellow" "$white"
			printf "Home Directory: %b$(grep -w "^$usern" /etc/passwd | awk -F ":" '{print $6}')%b\n" "$yellow" "$white"
			printf "Shell Directory: %b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $7}')%b\n" "$yellow" "$white"
			printf "Groups:%b$(groups "$usern" | awk -F ":" '{print $2}')%b\n\n" "$yellow" "$white"
		else
			printf "%bERROR: USER %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$usern" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;
		
	# Delete user
	"ud")
		clear
		sysman_logo
		printf "%b	    DELETE USER		%b\n\n" "$red" "$white"
		printf "Users:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)%b \n\n" "$blue" "$white"
		read -rp "Enter user: " usern
		if id "$usern" > /dev/null 2>&1; then # Checks if user exists and output goes to null
			printf "\n"
			read -p "Are you sure you want to delete the user ""$usern""? (y/n) > " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then 
				sudo userdel --remove "$usern" 2>/dev/null
				printf "\n\n%bUser%b: '%b' %bdeleted successfully!%b\n\n" "$green" "$white" "$usern" "$green" "$white"
			else
				printf "\n\n%bUser%b: '%b' %bwas not deleted!%b\n\n" "$red" "$white" "$usern" "$red" "$white"
			fi
		else
			printf "\n%bERROR: USER %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$usern" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;
		
	# Modify user properties
	"um")
		clear
		sysman_logo
		printf "%b	    USER MODIFICATION		%b\n\n" "$green" "$white"
		printf "Users:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)%b \n\n" "$blue" "$white"
		read -rp "Enter user: " usern
		if id "$usern" > /dev/null 2>&1; then
			printf "%b%b%b$(id -u "^$usern")" "$green" "\nUser ID: " "$white"
			printf "%b%b%b$(id -g "^$usern")" "$green" "\nGroup ID: " "$white"
			printf "%b%b%b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $5}')" "$green" "\nComment: " "$white"
			printf "%b%b%b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $6}')" "$green" "\nHome Directory: " "$white"
			printf "%b%b%b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $7}')" "$green" "\nShell Directory: " "$white"
			printf "%b%b%b$(groups "$usern" | awk -F ":" '{print $2}')" "$green" "\nGroups:" "$white"
			printf "\n\n"
			printf "What property would you like to modify?\n\n"
			printf  "%bPASSWORD%b | %bUSERNAME%b | %bGROUP%b | %bUSERID%b | %bGROUPID%b | %bCOMMENT%b | %bHOME%b | %bSHELL%b\n\n" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white"
			read -rp "> " modifier
			printf "\n"
			case "$modifier" in 
				"password" | "PASSWORD")
					passwd "$usern"
					;;
				"username" | "USERNAME")
					printf "Current username: %b%b%b\n\n" "$yellow" "$usern" "$white"
					read -rp "Enter new username: " new_usern
					printf "\n"
					read -p "Are you sure you want to change the username to '$new_usern'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -l "$new_usern" "$usern"; then
							printf "\n\n%bSUCCESS! NEW USERNAME: %b'%b'\n\n" "$green" "$white" "$new_usern"
						else
							printf "\n\n%bERROR: USERNAME %b'%b'%b WAS NOT CHANGED, TRY ANOTHER USERNAME!%b\n\n" "$red" "$white" "$usern" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: USERNAME %b'%b'%b WAS NOT CHANGED!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white"
					fi
					;;
				"group" | "GROUP")
					printf "Current default group: %b$(id -gn "$usern")%b\n\n" "$yellow" "$white"
					read -rp "Enter new default group: " new_grp
					printf "\n"
					read -p "Are you sure you want to change the primary group to '$new_grp'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -g "$new_grp" "$usern"; then
							printf "\n\n%bSUCCESS! NEW DEFAULT GROUP: %b'%b'\n\n" "$green" "$white" "$new_grp"
						else
							printf "\n\n%bERROR: DEFAULT GROUP WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$red" "$white" "$new_grp" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: DEFAULT GROUP WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$new_grp" "$yellow" "$white"
					fi
					;;
				"userid" | "USERID")
					printf "Current User ID: %b$(id -u "$usern")%b\n\n" "$yellow" "$white"
					read -rp "Enter new user id: " new_uid
					printf "\n"
					read -p "Are you sure you want to change the user id to '$new_uid'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -u "$new_uid" "$usern"; then
							printf "\n\n%bSUCCESS! NEW USER ID: %b'%b'\n\n" "$green" "$white" "$new_uid"
						else
							printf "\n\n%bERROR: USER ID FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$red" "$white" "$usern" "$red" "$white" "$new_uid" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: USER ID FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$new_uid" "$yellow" "$white"
					fi
					;;
				"groupid" | "GROUPID")
					printf "Current Group ID: %b$(id -g "$usern")%b\n\n" "$yellow" "$white"
					read -rp "Enter new group id: " new_gid
					printf "\n"
					read -p "Are you sure you want to change the group id to '$new_gid'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -u "$new_gid" "$usern"; then
							printf "\n\n%bSUCCESS! NEW USER ID: %b'%b'\n\n" "$green" "$white" "$new_gid"
						else
							printf "\n\n%bERROR: USER ID FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$red" "$white" "$usern" "$red" "$white" "$new_gid" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: USER ID FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$new_gid" "$yellow" "$white"
					fi
					;;
				"comment" | "COMMENT")
					printf "%b%b%b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $5}')" "$green" "\nCurrent Comment: " "$white"
					read -rp "Enter new comment: " new_com
					printf "\n"
					read -p "Are you sure you want to change the comment to '$new_com'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -c "$new_com" "$usern"; then
							printf "\n\n%bSUCCESS! NEW COMMENT: %b'%b'\n\n" "$green" "$white" "$new_com"
						else
							printf "\n\n%bERROR: COMMENT FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$red" "$white" "$usern" "$red" "$white" "$new_com" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: COMMENT FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$new_com" "$yellow" "$white"
					fi
					;;
				"home" | "HOME")
					printf "%b%b%b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $6}')" "$green" "\nCurrent Home Directory: " "$white"
					read -rp "Enter new home directory: /home/" new_home
					printf "\n"
					read -p "Are you sure you want to change the home directory to '/home/$new_home'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -d "/home/$new_home" "$usern"; then
							printf "\n\n%bSUCCESS! NEW HOME DIRECTORY: %b'/home/%b'\n\n" "$green" "$white" "$new_home"
						else
							printf "\n\n%bERROR: HOME DIRECTORY FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$red" "$white" "$usern" "$red" "$white" "$new_home" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: HOME DIRECTORY FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$new_home" "$yellow" "$white"
					fi
					;;
				"shell" | "SHELL")
					printf "%b%b%b$(grep -w "^$usern" /etc/passwd| awk -F ":" '{print $7}')" "$green" "\nCurrent Shell Directory: " "$white"
					read -rp "Enter new shell: /bin/" new_sh
					printf "\n"
					read -p "Are you sure you want to change the shell to '/bin/$new_sh'? (y/n) > " -n 1 -r
					if [[ $REPLY =~ ^[Yy]$ ]]; then
						if usermod -s "/bin/$new_sh" "$usern"; then
							printf "\n\n%bSUCCESS! NEW SHELL: %b'/bin/%b'\n\n" "$green" "$white" "$new_sh"
						else
							printf "\n\n%bERROR: SHELL FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$red" "$white" "$usern" "$red" "$white" "$new_sh" "$red" "$white"
						fi
					else
						printf "\n\n%bINFO: SHELL FOR %b'%b'%b WAS NOT CHANGED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$new_sh" "$yellow" "$white"
					fi
					;;
				*)
				    printf "%bERROR...%b [Invalid Selection: '%s'] \n\n" "$red" "$white" "$modifier"
					;;
			esac
		else
			printf "\n%bERROR: USER %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$usern" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;
		
	# Create group
	"ga")
		clear
		sysman_logo
		printf "%b	    CREATE GROUP		%b\n\n" "$yellow" "$white"
		read -rp "Enter name of new group: " group
		groups=$(getent group "$group" | cut -d ":" -f 1)
		if [[ "$groups" == "$group" ]]; then
			printf "\n%bERROR: GROUP %b'%b'%b ALREADY EXISTS!%b\n\n" "$red" "$white" "$group" "$red" "$white"
		else
			printf "\n%bCreating group%b: '%b'\n\n" "$green" "$white" "$group"
			read -p "Is this correct? (y/n) > " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo addgroup "$group" 2>/dev/null
				printf "\n\n%bGroup%b: '%b' %bwas created successfully!%b\n\n" "$green" "$white" "$group" "$green" "$white"
			else
				printf "\n\n%bGroup%b: '%b' %bwas not created!%b\n\n" "$red" "$white" "$group" "$red" "$white"
			fi
		fi
		read -rp "Press enter to continue..."
		;;
		
	# Lists all user groups
	"gl")
		clear
		sysman_logo
		printf "%b		GROUPS		%b\n\n" "$green" "$white"
		printf "Groups:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" && $1 != "autologin" {print $1}' /etc/group)%b \n\n" "$blue" "$white"
		read -rp "Press enter to continue..."
		;;

	# View specifed group
	"gv")
		clear
		sysman_logo
		printf "%b	    GROUP VIEW		%b\n\n" "$green" "$white"
		printf "Groups:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" && $1 != "autologin" {print $1}' /etc/group)%b \n\n" "$blue" "$white"
		read -rp "Enter group: " group
		if ! getent group "$group" > /dev/null; then
			printf "%bGroup '%s' not found.%b\n" "$red" "$group" "$white"
		else
			group_info=$(getent group "$group")
			IFS=':' read -r group group_pw group_gid group_members <<< "$group_info"

			printf "\nName: %b%s%b\n" "$blue" "$group" "$white"
			printf "Password (x = empty): %b%s%b\n" "$blue" "$group_pw" "$white"
			printf "GID: %b%s%b\n" "$blue" "$group_gid" "$white"
			printf "Members: %b%s%b\n" "$blue" "$group_members" "$white"
			
			num_members=$(getent group "$group" | awk -F '[,:]' '{ print NF - 3 }' | sort -k2,2n)
			printf "Size (Members count): %b%s%b\n\n" "$blue" "$num_members" "$white"
		fi
		printf ""
		read -rp "Press enter to continue..."
		;;
	
	# Add/Remove user from group
	"gm")
		clear
		sysman_logo
		printf "%b	    ADD/REMOVE USER FROM GROUP		%b\n\n" "$green" "$white"
		printf "Users:\n"
		printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)%b \n\n" "$blue" "$white"
		read -rp "Enter user: " usern
		if id "$usern" > /dev/null 2>&1; then
			clear
			sysman_logo
			printf "%b	    ADD/REMOVE USER FROM GROUP		%b\n\n" "$green" "$white"
			printf "Groups:\n"
			printf "%b$(awk -F: '$3 >= 1000 && $1 != "nobody" && $1 != "autologin" {print $1}' /etc/group)%b \n\n" "$blue" "$white"
			read -rp "Enter group: " group
			if getent group "$group" > /dev/null 2>&1; then
				printf "User selected: %b" "$usern"
				printf "Group selected: %b" "$group"
				printf "Do you want to (add) or (remove) %b from %b?" "$usern" "$group"
				read -rp "> " add_or_remove
				printf "\n"
				if [[ "$add_or_remove" == "add" ]]; then
					if usermod -aG "$usern" "$group"; then
						printf "\n\n%bSUCCESS! USER: %b'%b'%b HAS BEEN ADDED TO %b'%b'\n\n" "$green" "$white" "$usern" "$green" "$group" "$white"
					else
						printf "\n\n%bINFO: USER %b'%b'%b WAS NOT ADDED TO %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$group" "$yellow" "$white"
					fi
				elif [[ "$add_or_remove" == "remove" ]]; then
					if gpasswd -d "$usern" "$group"; then
						printf "\n\n%bSUCCESS! USER: %b'%b'%b HAS BEEN REMOVED FROM %b'%b'\n\n" "$green" "$white" "$usern" "$green" "$group" "$white"
					else
						printf "\n\n%bINFO: USER %b'%b'%b WAS NOT REMOVED FROM %b'%b'%b!%b\n\n" "$yellow" "$white" "$usern" "$yellow" "$white" "$group" "$yellow" "$white"
					fi
				else
					printf "ERROR... [Invalid Selection: '%s'] \n\n" "$add_or_remove"		
				fi
			else
				printf "%bERROR: GROUP %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$group" "$red" "$white"
			fi
		else
			printf "%bERROR: USER %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$usern" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;
	
	# Delete group
	"gd")
		clear
		sysman_logo
		printf "%b	    DELETE GROUP		%b\n\n" "$yellow" "$white"
		read -rp "Enter name of the group: " group
		groups=$(getent group "$group" | cut -d ":" -f 1)
		if [[ "$groups" == "$group" ]]; then
			printf "\n%bDeleting group%b: '%b'\n\n" "$green" "$white" "$group"
			read -p "Are you sure? (y/n) > " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo delgroup "$group" 2>/dev/null
				printf "\n\n%bGroup%b: '%b' %bwas deleted successfully!%b\n\n" "$green" "$white" "$group" "$green" "$white"
			else
				printf "\n\n%bGroup%b: '%b' %bwas not deleted!%b\n\n" "$red" "$white" "$group" "$red" "$white"
			fi
		else
			printf "\n%bERROR: GROUP %b'%b'%b ALREADY EXISTS!%b\n\n" "$red" "$white" "$group" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;
	
	# Create folder
	"fa")
		clear
		sysman_logo
		printf "%b	   CREATE NEW FOLDER		%b\n\n" "$green" "$white"
		read -rp "Enter folder name: " folder
		printf "\n"
		read -rp "Enter folder's parent directory in absolute path: " folder_path
		folder_path="${folder_path//\'/}"
		if [[ -d "$folder_path" ]]; then
			if [[ ! -d "$folder_path/$folder" ]]; then
				mkdir "$folder_path/$folder"
				printf "\n%bSUCCESS! Folder %b'%b'%b was created successfully!%b\n\n" "$green" "$white" "$folder" "$green" "$white"
			else
				printf "\n%bERROR: FOLDER%b'%b'%b ALREADY EXISTS!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
			fi
		else
			printf "\n%bERROR: PARENT DIRECTORY %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$folder_path" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;

	# View content of folder
	"fl")
		clear
		sysman_logo
		printf "%b	   FOLDER CONTENTS		%b\n\n" "$yellow" "$white"
		read -rp "Enter folder's absolute path: " folder
		folder="${folder//\'/}"
		if [[ -d "$folder" ]]; then
			printf "\nPATH: %b%s%b\n\n" "$blue" "$folder" "$white"
			printf "%bContents of folder:%b\n" "$red" "$white"
			for file in "$folder"/*; do
				if [[ -d "$file" ]]; then
					printf "%b%s%b\n" "$green" "$(basename "$file")" "$white"
				elif [[ -f "$file" ]]; then
					printf "%b%s%b\n" "$yellow" "$(basename "$file")" "$white"
				else
					printf "%b%s%b\n" "$red" "$(basename "$file")" "$white"
				fi
			done
			printf "\n"
		else
			printf "\n%bERROR: FOLDER %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;

	# View folder properties
	"fv")
		clear
		sysman_logo
		printf "%b	   FOLDER PROPERTIES		%b\n\n" "$green" "$white"
		read -rp "Enter folder's absolute path: " folder
		folder="${folder//\'/}"
		if [[ -d "$folder" ]]; then
			printf "\nPATH: %b%s%b\n\n" "$blue" "$folder" "$white"
			printf "Owner: %b%s%b\n" "$blue" "$(stat -c '%U' "$folder")" "$white"
			printf "Group: %b%s%b\n\n" "$blue" "$(stat -c '%G' "$folder")" "$white"
			printf "Permissions: %b%s%b\n" "$blue" "$(stat -c '%A' "$folder")" "$white"
			perm_string="$(stat -c '%a' "$folder")"
			octal="${perm_string: -3}"
			perm_list=""
			for (( i = 1; i <= 3; i++ )); do
				perm_number="${octal:i-1:1}"
				case $i in
					1) perm_list+="Owner: ";;
					2) perm_list+="Group: ";;
					3) perm_list+="Others: ";;
				esac
				case $perm_number in
					"7") perm_list+="Read, Write & Execute\n";;
					"6") perm_list+="Read & Write\n";;
					"5") perm_list+="Read & Execute\n";;        
					"4") perm_list+="Read\n";;
					"3") perm_list+="Write & Execute\n";;
					"2") perm_list+="Write\n";;
					"1") perm_list+="Execute\n";;
					"0") perm_list+="No permissions\n";;
				esac
			done
			printf "%b" "$perm_list"
			perm_sgid="$(stat -c '%A' "$folder" | cut -c 10)"
			perms_stick="$(stat -c '%A' "$folder" | cut -c 7)"
			if [[ "$perm_sgid" == "s" ]]; then
				printf "SGID: %bYES%b\n" "$green" "$white"
			else
				printf "SGID: %bNO%b\n" "$red" "$white"
			fi
			if [[ "$perms_stick" == "t" ]]; then
				printf "Sticky bit: %bYES%b\n" "$green" "$white"
			else
				printf "Sticky bit: %bNO%b\n" "$red" "$white"
			fi
			printf "\nCreated: %b%s%b\n" "$blue" "$(stat -c '%w' "$folder")" "$white"
			printf "Last modified: %b%s%b\n" "$blue" "$(stat -c '%y' "$folder")" "$white"
			printf "Last accessed: %b%s%b\n\n" "$blue" "$(stat -c '%x' "$folder")" "$white"
		else
			printf "\n%bERROR: FOLDER %b%b%b WAS NOT FOUND!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
		fi
		read -rp "Press enter to continue..."
		;;

	# Modify folder properties
	"fm")
		clear
		sysman_logo
		printf "%b	   FOLDER MODIFICATION		%b\n\n" "$yellow" "$white"
		read -rp "Enter folder's absolute path: " folder
		folder="${folder//\'/}"
		if [[ -d "$folder" ]]; then
			printf "\nWhich property would you like to modify?\n\n"
			printf  "%bOWNER%b | %bGROUP%b | %bPERMISSIONS%b | %bSTICKY BIT%b | %bSETGID%b\n\n" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white"
			read -rp "> " modifier
			case $modifier in
			"owner"|"OWNER")
				printf "\nCurrent owner: %b%s%b\n\n" "$yellow" "$(stat -c '%U' "$folder")" "$white"
				read -rp "Enter new owner: " new_owner
				printf "\n"
				read -p "Are you sure you want to change the owner to '$new_owner'? (y/n) > " -n 1 -r
				printf "\n\n"
				chown -v "$new_owner" "$folder"
				printf "\n"
				;;
			"group"|"GROUP")
				printf "\nCurrent group: %b%s%b\n\n" "$yellow" "$(stat -c '%G' "$folder")" "$white"
				read -rp "Enter new group: " new_group
				printf "\n"
				read -p "Are you sure you want to change the group to '$new_group'? (y/n) > " -n 1 -r
				printf "\n\n"
				chgrp -v "$new_group" "$folder"
				printf "\n"
				;;
			
			"permissions"|"PERMISSIONS")
				printf "\nWhat permissions would you like to change?\n\n"
				printf "%b(R)ead%b | %b(W)rite%b | %bE(X)ecute%b | %b(A)ll%b\n\n" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white"
				read -rp "> " -n 1 perm_select	
				perm_select="${perm_select,,}"
				if [[ $perm_select == "a" || $perm_select == "A" ]]; then
					printf "\n\nWho's permissions would you like to change?\n"
					printf "\n%b(U)ser Owner%b | %b(G)roup%b | %b(O)ther%b\n\n" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white"
					read -rp "> " -n 1 who_select
					who_select="${who_select,,}"
					if [[ $who_select == "u" || $who_select == "U" ]]; then
						if chmod u+rwx "$folder"; then
							printf "\n\n%bSUCCESS! OWNER PERMISSIONS ADDED TO: %b'%b\n\n" "$green" "$white" "$folder"
						else
							printf "\n\n%bERROR: OWNER PERMISSIONS %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
						fi
					elif [[ $who_select == "g" || $who_select == "G" ]]; then
						if chmod g+rwx "$folder"; then
							printf "\n\n%bSUCCESS! GROUP PERMISSIONS ADDED TO: %b'%b'\n\n" "$green" "$white" "$folder"
						else
							printf "\n\n%bERROR: GROUP PERMISSIONS %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
						fi
					elif [[ $who_select == "o" || $who_select == "O" ]]; then
						if chmod o+rwx "$folder"; then
							printf "\n\n%bSUCCESS! OTHERS PERMISSIONS ADDED TO: %b'%b'\n\n" "$green" "$white" "$folder"
						else
							printf "\n\n%bERROR: OTHERS PERMISSIONS %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
						fi
					else
						printf "\n\n%bERROR...%b [Invalid Selection: '%s'] \n\n" "$red" "$white" "$who_select"
					fi
				elif [[ $perm_select == "r" || $perm_select == "R" || $perm_select == "w" || $perm_select == "W" || $perm_select == "x" || $perm_select == "X" ]]; then
					printf "\n\nWho's permissions do you want to change?\n\n"
					printf "%b(U)ser Owner%b | %b(G)roup%b | %b(O)ther%b\n\n" "$yellow" "$white" "$yellow" "$white" "$yellow" "$white"
					read -rp "> " -n 1 who_select
					who_select="${who_select,,}"
					printf "\n\nDo you want to (add) or (remove) permission: '%b'?\n\n" "$perm_select"
					read -rp "> " add_or_remove
					add_or_remove="${add_or_remove,,}"
					if [[ $add_or_remove == "add" ]]; then
						if chmod "$who_select"+"$perm_select" "$folder"; then
							printf "\n%bSUCCESS! %b'%b'%b PERMISSIONS ADDED TO: %b'%b'\n\n" "$green" "$white" "$folder" "$green" "$white" "$perm_select"
						else
							printf "\n%bERROR: %b'%b'%b PERMISSIONS %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white" "$perm_select" "$red" "$white"
						fi
					elif [[ $add_or_remove == "remove" ]]; then
						if chmod "$who_select"-"$perm_select" "$folder"; then
							printf "\n%bSUCCESS! %b'%b'%b PERMISSIONS REMOVED FROM: %b'%b'\n\n" "$green" "$white" "$folder" "$green" "$white" "$perm_select"
						else
							printf "\n%bERROR: %b'%b'%b PERMISSIONS %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white" "$perm_select" "$red" "$white"
						fi
					else
						printf "\n%bERROR...%b [Invalid Selection: '%s'] \n\n" "$red" "$white" "$add_or_remove"
					fi
				else
					printf "\n%bERROR...%b [Invalid Selection: '%s'] \n\n" "$red" "$white" "$perm_select"
				fi
				;;
			"sticky bit"|"STICKY BIT")
				printf "\nSticky bit: %b%s%b\n\n" "$yellow" "$(stat -c '%A' "$folder" | grep -q '[tT]$' && echo enabled || echo disabled)" "$white"
				read -p "Do you want to enable or disable the sticky bit? (e/d) > " -n 1 -r
				if [[ $REPLY =~ ^[Ee]$ ]]; then
					if chmod +t "$folder"; then
						printf "\n\n%bSUCCESS! STICKY BIT ENABLED: %b'%b'\n\n" "$green" "$white" "$folder"
					else
						printf "\n\n%bERROR: STICKY BIT %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
					fi
				elif [[ $REPLY =~ ^[Dd]$ ]];then
					if chmod -t "$folder";then
						printf "\n\n%bSUCCESS! STICKY BIT DISABLED: %b'%b'\n\n" "$green" "$white" "$folder"
					else
						printf "\n\n%bERROR: STICKY BIT %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
					fi
				else
					printf "\n\n%bERROR...%b [Invalid Selection: '%s'] \n\n" "$red" "$white" "$REPLY"
				fi
				;;
			"setgid"|"SETGID")
				printf "\nSGID bit: %b%s%b\n\n" "$yellow" "$( [[ $(stat -c '%A' "$folder") =~ [sS] ]] && echo enabled || echo disabled )" "$white"
				read -p "Do you want to enable or disable the setgid? (e/d) > " -n 1 -r
				if [[ $REPLY =~ ^[Ee]$ ]]; then
					if chmod g+s "$folder"; then
						printf "\n\n%bSUCCESS! SETGID ENABlED: %b'%b'\n\n" "$green" "$white" "$folder"
					else
						printf "\n\n%bERROR: SETGID %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
					fi
				elif [[ $REPLY =~ ^[Dd]$ ]]; then
					if chmod g-s "$folder"; then
						printf "\n\n%bSUCCESS! SETGID DISABLED: %b'%b'\n\n" "$green" "$white" "$folder"
					else
						printf "\n\n%bERROR: SETGID %b'%b'%b NOT CHANGED!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
					fi
				else
					printf "\n\n%bERROR...%b [Invalid Selection: '%s'] \n\n" "$red" "$white" "$REPLY"
				fi
				;;
			esac
		fi
		read -rp "Press enter to continue..."
		;;
		
	# Delete folder
	"fd")
		clear
		sysman_logo
		printf "%b	    DELETE FOLDER		%b\n\n" "$yellow" "$white"
		read -rp "Enter folder's absolute path: " folder
		folder="${folder//\'/}"
		if [[ -d "$folder" ]]; then
			printf "\nDeleting folder: %b'%b'%b\n\n" "$green" "$folder" "$white"
			read -p "Are you sure? (y/n) > " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo rm -rf "$folder"
				printf "\n\n%bFolder%b: '%b' %bwas deleted successfully!%b\n\n" "$green" "$white" "$folder" "$green" "$white"
			else
				printf "\n\n%bFolder%b: '%b' %bwas not deleted!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
			fi
		else
			printf "\n%bERROR: FOLDER %b'%b'%b NOT FOUND!%b\n\n" "$red" "$white" "$folder" "$red" "$white"
		fi
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
		if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]];then
			packageToInstall gnome-software-plugin-flatpak
		elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]];then
			packageToInstall plasma-discover-backend-flatpak
		fi
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		printf "%bSuccessfully installed Flathub and added Flathub as repository! %b\n\n" "$green" "$white"
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
				printf "%bUnlock the AppImage and move it to the app menu.%b\n" "$green" "$white"
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
				sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
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
			clear
			printf "By default, DNF has pretty conservative settings for max_parallel_downloads and using the fastest mirror.\n"
			printf "Adding more capacity and allowing fastest mirror can speed up package handling. \n\n"
			read -p "Do you want to increase max_parallel_download and always use the fastest mirror? (y/n) > " -n 1 -r
			printf "\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if grep -q "max_parallel_downloads=" /etc/dnf/dnf.conf; then
    				sudo sed -i '/^max_parallel_downloads=/c\max_parallel_downloads=10' /etc/dnf/dnf.conf
				else
    				printf "\nmax_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
				fi
				if grep -q "fastestmirror" /etc/dnf/dnf.conf; then
    				sudo sed -i 's/^fastestmirror=.*/fastestmirror=true/' /etc/dnf/dnf.conf
				else
    				printf "\nfastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
				fi
				printf "\n"
				printf "Increased max_parallel_download to 10 and set fastestmirror to true. \n\n"
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
				sudo usermod -a -G libvirt "$(whoami)"
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
		read -rp "Selection > " deb_select;
		printf "\n"
    	case $deb_select in
		"nvi")
			if [[ "$(cat /etc/*-release)" =~ Ubuntu ]]; then
				read -p "It seems like you are running Ubuntu. Would you like to switch to Ubuntu's automatic driver installer? (y/n) > " -n 1 -r
				printf "\n"
				if [[ $REPLY =~ ^[Yy]$ ]]; then
					printf "%bInstalling...%b\n\n" "$yellow" "$white"
					sudo ubuntu-drivers install
				fi
			else
				printf "For best performance on Linux, it's best to use the proprietary nvidia driver.\n\n"
				read -p "Do you want to install the nvidia driver? (y/n) > " -n 1 -r
				printf "\n"
				if [[ $REPLY =~ ^[Yy]$ ]]; then
					driverInstalled=$(nvidia-smi | grep -o "Driver Version")
					if [[ $driverInstalled ]]; then
						printf "Nvidia drivers already installed.\n"
					else
						if [[ "$(cat /etc/*-release)" =~ bookworm ]]; then
							printf "%bInstalling...%b\n\n" "$yellow" "$white"
							packageToInstall linux-headers-amd64
							printf "deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
							sudo apt-get update -y
							packageToInstall nvidia-driver firmware-misc-nonfree -y
							printf "%bInstallation complete. For the drivers to be applied you need to reboot.%b\n" "$yellow" "$white"
							read -p "Reboot now? (y/n) > " -n 1 -r
							if [[ $REPLY =~ ^[Yy]$ ]]; then
								sudo reboot
							fi
						fi  # <-- This was missing
						if [[ "$(cat /etc/*-release)" =~ bullseye ]]; then
							printf "%bInstalling...%b\n\n" "$yellow" "$white"
							packageToInstall linux-headers-amd64
							printf "deb http://deb.debian.org/debian/ bullseye main contrib non-free" | sudo tee -a /etc/apt/sources.list
							sudo apt-get update
							packageToInstall nvidia-driver firmware-misc-nonfree
							printf "%bInstallation complete. For the drivers to be applied you need to reboot.%b\n" "$yellow" "$white"
							read -rp "Reboot now? > (y/n)\n"
							if [[ $REPLY =~ ^[Yy]$ ]]; then
								sudo reboot
							fi
						fi 
					fi
				fi
			fi
			;;
		esac
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
				if lspci | grep -q "VGA" | grep -q "NVIDIA" && grep -q "Arch" /etc/*-release; then
					gpu_model=$(lspci | grep VGA | grep NVIDIA | sed -n 's/.*Corporation\s*\([A-Za-z][A-Za-z]\).*/\1/p')
					if [[ "$gpu_model" =~ (TU|GA|AD)$ ]]; then
						cpu_model=$(grep "model name" /proc/cpuinfo | head -n 1 | cut -d ':' -f 2 | sed -E 's/.*i[3579]-([0-9]{4}).*/\1/' | cut -c1-2) # Removed useless cat
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
							if ! grep -qw "ibt=off" /etc/default/grub; then
								sudo sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 ibt=off"/' /etc/default/grub
								sudo grub-mkconfig -o /boot/grub/grub.cfg
							else
								printf "Kernel is already set up.\n"
							fi
						fi
						read -p "Do you want to reboot now to reload the new driver? (y/n) > " -n 1 -r
						printf "\n"
						if [[ $REPLY =~ ^[Yy]$ ]]; then
							sudo reboot
						fi
					else
						printf "Unsupported hardware or Linux distribution.\n"
					fi
				else
					printf "NVIDIA Hardware not found.\n\n"
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
		sysman_logo
		printf "%b	 FIRMWARE UPDATER		%b\n\n" "$green" "$white"
		printf "%bfwupd%b is a simple daemon to allow session software to update device firmware on your local machine.\n\n" "$yellow" "$white"
		if mokutil --sb-state | grep -q 'SecureBoot enabled'; then
			printf "SecureBoot is enabled, it's not recommend to update firmware within Linush for SecureBoot-enabled systems.\n\n"
		else
			read -p "Do you want to check for system firmware updates and install them if found? (y/n) > " -n 1 -r
			printf "\n\n"
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				if [ -x "$(command -v fwupdmgr)" ];then
					printf "%bfwupd%b is already installed...\n\n" "$yellow" "$white"
				else
					packageToInstall fwupd
				fi
				fwupdmgr refresh --force
				fwupdmgr get-updates
				fwupdmgr update
				printf "\n"
			else
				printf "%bNot updating firmware...%b" "$red" "$white"
			fi
		fi
		read -rp "Press enter to continue..."
		;;

	# If the selection is invalid
	*)
        printf "ERROR... [Invalid Selection: '%s'] \n\n" "$selection"
		read -rp "Press enter to continue..."
        ;;		
esac

done