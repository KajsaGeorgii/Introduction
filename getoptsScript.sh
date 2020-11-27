#!/bin/bash
while getopts ":h:t:" opt; do
        case $opt in
		h) a="$OPTARG"
		;;
		t) b="$OPTARG"	
		;;
        esac
done


#calculate mean
if [ ! -z "$a" ]; then
	cat "$a" | awk  -v u="{$b}" '{x+=$(u); next} END {print x/NR}' 

fi 

#calculate stdev
if [ ! -z "$a" ]; then 
	cat "$a" | awk  -v a="{$b}" '{x+=$(a);y+=$(a)^2}END{print sqrt(y/NR-(x/NR)^2)}'

fi

if [ ! -z "$a" ]; then
	tot="$(cat "$a" | wc -l)"
	cat "$a" | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk	-v a="${tot}" '{print $0/a, $2}'

fi



