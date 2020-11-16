
#create bash funtion to calc nr of single nucleotides
function single_nucleotides { 
	echo "Input file:"; read file; 
	tot="$(cat $file | wc -l)";
	cat $file | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk	-v a="${tot}" '{print $0/a, $2}'; 
	}
