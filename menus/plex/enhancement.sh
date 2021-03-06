#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com

HEIGHT=12
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Plex Installer"
MENU="Make a Selection:"

OPTIONS=(A "Generate a PlexToken"
         B "Add Your Plex Library"
         C "Install DupeFinder"
         D "Deploy Telly (Not Ready)"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)
            bash /opt/plexguide/scripts/plextoken/main.sh
            ;;
        B)
            bash /opt/plexguide/menus/dupefinder/paths.sh
            ;;
        C)
            file="/opt/appdata/plexguide/plextoken"
            if [ -e "$file" ]
            then
                echo "" 1>/dev/null 2>&1
            else
                dialog --title "--- WARNING ---" --msgbox "\nYou need to create a PLEXToken!\n\nYou must have not read the Wiki!" 0 0
                bash /opt/plexguide/menus/plex/enhancement.sh
                exit
            fi

            file="/var/plexguide/plex.library.json"
            if [ -e "$file" ]
            then
                echo "" 1>/dev/null 2>&1
            else
                dialog --title "--- WARNING ---" --msgbox "\nYou need to create your Library layout for us!\n\nYou must have not read the Wiki!" 0 0
                bash /opt/plexguide/menus/plex/enhancement.sh
                exit
            fi

            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags dupefinder
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        D)
            bash /opt/plexguide/menus/plex/telly.sh
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/plex/enhancement.sh
