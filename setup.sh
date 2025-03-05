#!/usr/bin/env bash

GREEN="\033[0;32m"
CYAN="\033[0;36m"
NC="\033[0m"

apps=(
	config
	git
	tmux
	vim
)

stowit() {
	usr=$1
	app=$2
	printf "stowing ${CYAN}${app}${NC}... "
	stow -R -t ${usr} ${app} >/dev/null # -R recursive, -t target
	echo -e "${GREEN}DONE${NC}"
}

for app in ${apps[@]}; do
	stowit "${HOME}" $app
done
