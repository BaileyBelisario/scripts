#!/bin/bash
# Author: Bailey Belisario (ZoneMix)
# 
# This script is meant for automation of HackTheBox scans
# or making challenge and box directories with ease
#
clear

box=$(echo ~/Documents/htb/boxes)
chal=$(echo ~/Documents/htb/challenges)

if [[ ! -d $chal ]]; then
	mkdir -p $chal
fi

if [[ ! -d $chal ]]; then
	mkdir -p $box
fi

#mkdir -p ~/Documents/htb/challenges
printf "\n"
printf "     -=== Welcome to EaseHTB ===-\n\n"
printf "          ------------------\n"
printf "          |    Make Menu   |\n"
printf "          ------------------\n"
printf "          |       Box == B |\n"
printf "          | Challenge == C |\n"
printf "          ------------------\n\n"
printf "   Choice: "
read choice

if [[ $choice == 'B' || $choice == 'b' ]]; then
	clear
	printf "\n--------------------------------\n"
	printf "|Box Name: "
	read dir
	printf "|-------------------------------\n"
	printf "|IP: "
	read ip
	printf "|-------------------------------\n\n"

	if [[ $ip != *"."*"."*"."* ]]; then printf "!!Invalid IP!!\n\n\n"; exit 1; fi

	printf "Making directory '$dir' in '~/Documents/htb/boxes'...\n"

	cd ~/Documents/htb/boxes
	mkdir $dir
	cd $dir
	mkdir nmap
	cd nmap

	printf "Full port scan [Y/n]: "
	read choice

	printf "\nRunning nmap scan on $dir"

	if [[ $choice == 'n' || $choice == 'N' ]]; then
		nmap -sV -sC -T5 -oA $dir $ip > /dev/null 2>&1 &
	else	
		nmap -sV -sC -T5 -oA $dir $ip -p 1-65535 > /dev/null 2>&1 &
	fi
	pid=$!
	flag=0
	counter=0

	while [ $flag -eq 0 ]
	do
		if [[ $(ps -p $pid | grep $pid | cut -d ' ' -f1) == $pid || $(ps -p $pid | grep $pid | cut -d ' ' -f2) == $pid || $(ps -p $pid | grep $pid | cut -d ' ' -f3) == $pid || $(ps -p $pid | grep $pid | cut -d ' ' -f4) == $pid ]]
		then
			if [ $counter -lt 5 ]
			then
				sleep .5
				printf "."
				((counter++))
			fi
		else
			flag=1
		fi
	done

	sleep 1

	printf "\n\nNmap Scan Complete!\nScript finished!\n"

elif [[ $choice == 'C' || $choice == 'c' ]]; then
	exit 1
else
	printf "\nPlease enter a valid choice...\n\n"
fi
