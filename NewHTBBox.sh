#!/bin/bash

printf "Box Name: "
read dir

printf "IP: "
read ip

printf "\nMaking directory '$dir' in '~/Documents/htb/boxes'..."

cd ~/Documents/htb/boxes
mkdir $dir
cd $dir

sleep .5

printf "\nRunning nmap scan on $dir"

nmap -sV -sC -T5 -oA $dir $ip -p 1-65535 > /dev/null 2>&1 &
pid=$!
flag=0
counter=0

while [ $flag -eq 0 ]
do
	if [[ $(ps -p $pid | grep $pid | cut -d ' ' -f1) == $pid || $(ps -p $pid | grep $pid | cut -d ' ' -f2) == $pid || $(ps -p $pid | grep $pid | cut -d ' ' -f2) == $pid || $(ps -p $pid | grep $pid | cut -d ' ' -f4) == $pid ]]
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
