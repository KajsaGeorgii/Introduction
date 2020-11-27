#!/bin/bash
while getopts ":h:t:" opt; do
        case $opt in
		h) a="$OPTARG"
		;;
		t) b="$OPTARG"	
		;;
        esac
done

if [ ! -z "$a" ]; then
	cat "$a" | awk  -v u="{$b}" '{x+=$(u); next} END {print x/NR}' 

fi 

#shift $((OPTIND -1))


