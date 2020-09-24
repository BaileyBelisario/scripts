#!/bin/bash
# Author: Bailey Belisario (ZoneMix)
#
# This script is meant for automation of HackTheBox/TryHackMe scans
# or making directories for everything with ease
#
# Run ". ./EasyScan" or alias it, if you would like to have it go to enter the directory created once the script is finished
#
clear

box=$(echo ~/Documents/htb/boxes)
chal=$(echo ~/Documents/htb/challenges)
room=$(echo ~/Documents/tryhackme/rooms)

if [[ ! -d $chal ]]; then
	mkdir -p $chal
fi

if [[ ! -d $box ]]; then
	mkdir -p $box
fi

if [[ ! -d $room ]]; then
	mkdir -p $room
fi

printf "\n"
printf "     -=== Welcome to EasyScan ===-\n\n"
printf "          ------------------\n"
printf "          |    Make Menu   |\n"
printf "          ------------------\n"
printf "          |       Box == B |\n"
printf "          | Challenge == C |\n"
printf "          |      Room == R |\n"
printf "          ------------------\n\n"
printf "   Choice: "
read choice

if [[ $choice == "B" || $choice == "b" || $choice == "R" || $choice == "r" ]]; then
	clear
	printf "\n --------------------------------\n"
	printf " | Box/Room Name: "
	read dir
	printf " --------------------------------\n"
	printf " | IP: "
	read ip
	printf " --------------------------------\n\n"

	while [[ $ip != [0-9]*"."[0-9]*"."[0-9]*"."[0-9]* ]]
	do
		clear
		printf "\n\nError: Invalid IP!!\n\n"
		printf " --------------------------------\n"
		printf " | IP: "
		read ip
		printf " --------------------------------\n\n"
	done

	if [[ ($choice == "B") || ($choice == "b") ]]
	then
		printf "Making directory '$dir' in '$box'...\n"
		cd $box
	else
		printf "Making directory '$dir' in '$room'...\n"
		cd $room
	fi	

	mkdir $dir 2>/dev/null
	cd $dir
	mkdir nmap 2>/dev/null
	cd nmap

	printf "\n --------------------------------\n"
	printf " |         Normal Scan [n]      |\n"
	printf " |      Full Port Scan [f]      |\n"
	printf " |  Top-1000 Port Scan [q]      |\n"
	printf " --------------------------------\n\n"
	printf "Choice: "
	read choice

	until [[ $choice = "n" || $choice = "N" || $choice = "q" || $choice = "Q" || $choice = "f" || $choice = "F" ]]
	do
		clear
		printf "\n\nError: Please enter valid choice!!\n"
		printf "\n --------------------------------\n"
		printf " |         Normal Scan [n]      |\n"
		printf " |      Full Port Scan [f]      |\n"
		printf " |  Top-1000 Port Scan [q]      |\n"
		printf " --------------------------------\n\n"
		printf "Choice: "
		read choice
	done

	printf "\nRunning nmap scan on $dir"

	if [[ $choice == "n" || $choice == "N" ]]; then
		nmap -sV -A -T5 -Pn -oA $dir $ip > /dev/null 2>&1 &
	elif [[ $choice == "q" || $choice == "Q" ]]; then
		nmap -sV -A -T5 -Pn --top-ports=1000 -oA $dir $ip > /dev/null 2>&1 &
	elif [[ $choice == "f" || $choice == "F" ]]; then
		nmap -sV -A -T5 -Pn -oA $dir $ip -p- > /dev/null 2>&1 &
	fi
	pid=$!
	flag=0
	counter=0

	while [ $flag -eq 0 ]
	do
		if [[ $(ps -p $pid | grep $pid | cut -d " " -f1) == $pid || $(ps -p $pid | grep $pid | cut -d " " -f2) == $pid || $(ps -p $pid | grep $pid | cut -d " " -f3) == $pid || $(ps -p $pid | grep $pid | cut -d " " -f4) == $pid ]]
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
	cd ..

elif [[ $choice == "C" || $choice == "c" ]]; then
	clear
	printf "\n --------------------------------\n"
	printf " | Challenge Name: "
	read dir
	printf " --------------------------------\n"
	
	printf "Making directory '$dir' in '$chal'...\n"

	cd $chal
	mkdir $dir 2>/dev/null
	cd $chal
	cd $dir
else
	printf "\nPlease enter a valid choice...\n\n"
fi


