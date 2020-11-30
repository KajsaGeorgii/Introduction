#!/bin/bash
#calculate mean of a column
function mean { 
	cat "examples/gwas_depression_test_data.txt" | awk '{x+=$3; next} END {print x/NR}';
	}
mean

#calculate stdev of a column
function stdev { 
	cat "examples/gwas_depression_test_data.txt" | awk '{x+=$3;y+=$3^2}END{print sqrt(y/NR-(x/NR)^2)}';
	}


#create bash funtion to calc nr of single nucleotides
function single_nucleotides { 
	tot="$(cat "examples/gwas_depression_test_data.txt" | wc -l)";
	cat "examples/gwas_depression_test_data.txt" | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk	-v a="${tot}" '{print $0/a, $2}'; 
	}

arr=("a" "b")
for i in ${arr[@]}; do
	(mean $i; stdev $i; single_nucleotides $i) > info${i}.txt &
done
wait
echo "all done"


