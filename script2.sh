function single_nucleotides { 
	echo "Input file:"; read file; 
	local var=$(echo $file | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk 	-v a="$(echo $file | wc -l)" '{print $0/a; print $2}'); 
	awk -v a="$var" 'BEGIN {print a}';
	}
=======
#create bash funtion to calc nr of single nucleotides
