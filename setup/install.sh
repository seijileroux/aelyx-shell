#!/bin/bash

# === Variables === #
current_dir_location=$(pwd)
BOLD="\e[1m"
DIM="\e[2m"
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
GRAY="\e[90m"
RESET="\e[0m"

clear

# === Header === #
echo -e "${BOLD}${BLUE}	   >>> AELYX INSTALLER <<<${RESET}"
echo -e "${GRAY}---------------------------------------------${RESET}\n"

# === Notice === #
echo -e "${BOLD}NOTICE${RESET}"
echo -e "${GRAY}---------------------------------------------${RESET}"
echo -e "By running this installer, you acknowledge and accept:"
echo -e "  • Installation of the Aelyx configuration"
echo -e "  • Full responsibility for any system changes made\n"

echo -e "${DIM}The installation will begin in 5 seconds...${RESET}"
sleep 5

# === Bootstrap === #
echo -e "${BLUE}>> Running bootstrap script...${RESET}"
bash "$current_dir_location/bootstrap.sh"

# === File Deployment === #
echo -e "\n${BLUE}>> Copying configuration files...${RESET}"

mkdir -p ~/.config
mkdir -p ~/.local/share/aelyx

cp -r ../dots/.config/* ~/.config/ 
cp -r ../dots/.local/share/aelyx/* ~/.local/share/aelyx/

echo -e "${GREEN}✔ Successfully installed Aelyx!${RESET}\n"
echo -e "${GRAY}You're all set. Enjoy your new setup.${RESET}"

