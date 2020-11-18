
#call on rscript to execute histogram
Rscript histogram.R "examples/gwas_depression_test_data.txt"

#calculate mean of a column
function mean { 
	echo "Input file:"; read file; 
	echo "Input column:"; read var; 
	cat $file | awk  -v a="${var}" '{x+=$(a); next} END {print x/NR}';
	}
mean

#calculate stdev of a column
function stdev { 
	echo "Input file:"; read file; 
	echo "Input column:"; read var; 
	cat $file | awk  -v a="${var}" '{x+=$(a);y+=$(a)^2}END{print sqrt(y/NR-(x/NR)^2)}';
	}
stdev

#create bash funtion to calc nr of single nucleotides
function single_nucleotides { 
	echo "Input file:"; read file; 
	tot="$(cat $file | wc -l)";
	cat $file | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk	-v a="${tot}" '{print $0/a, $2}'; 
	}
single_nucleotides

