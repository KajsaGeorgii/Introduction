#!/bin/bash
#calculate mean of a column
function meanA { 
	cat "examples/xaa" | awk '{x+=$3; next} END {print x/NR}';
	}

#calculate stdev of a column
function stdevA { 
	cat "examples/xaa" | awk '{x+=$3;y+=$3^2}END{print sqrt(y/NR-(x/NR)^2)}';
	}


#create bash funtion to calc nr of single nucleotides
function single_nucleotidesA { 
	tot="$(cat "examples/xaa" | wc -l)";
	cat "examples/xaa" | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk	-v a="${tot}" '{print $0/a, $2}'; 
	}



#calculate mean of a column
function meanB {
        cat "examples/xab" | awk '{x+=$3; next} END {print x/NR}';
        }

#calculate stdev of a column
function stdevB {
        cat "examples/xab" | awk '{x+=$3;y+=$3^2}END{print sqrt(y/NR-(x/NR)^2)}';
        }


#create bash funtion to calc nr of single nucleotides
function single_nucleotidesB { 
        tot="$(cat "examples/xab" | wc -l)";
        cat "examples/xab" | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0    ] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk -v a="${tot}" '{print $0/a, $2}'; 
        }




#parallelisation of functions
arr=("a" "b")
for i in ${arr[@]}; do
	(meanA $0; stdevA $0; single_nucleotidesA $0) > infoA.txt &
	(meanB $1; stdevB $1; single_nucleotidesB $1) > infoB.txt &
done
wait
echo "all done"


