#!/bin/bash
#DESCRIPTION OF SCRIPT
#A parallelised pipeline starting from a GWAS sumstat file

sumstat="$1"
workdir="$2"

# What did we read from command line
echo "sumstat to read is: $sumstat"
echo "workdir to use for intermediary files is: $workdir"

# Get absolut path for sumstat
startdir="$(pwd)"
sumstat="$(pwd)/$sumstat"
workdir="$(pwd)/$workdir"

#make work directory if it doesnt exist
mkdir -p ${workdir}

################################################################################
# Step 1: Split sumstat in 2 parts
################################################################################
#make work directory sub folder for this process
mkdir -p ${workdir}/split_sumstats
#go to subfolder 
cd ${workdir}/split_sumstats
#split file
split -a3 -n 2 -d ${sumstat} 
#go back
cd ${startdir}

################################################################################
# Step 2: Apply function 1
################################################################################
#list available input
avail=("$(ls ${workdir}/split_sumstats)")

#make work directory sub folder for this process
mkdir -p ${workdir}/mean_sumstats

#calculate mean of a column
function meanX { 
  cat "${1}" | awk '{x+=$3; next} END {print x/NR}';
}

# Start the different parallell processes
for file in ${avail[@]}; do \
 ( \
 echo "$file starting ..."; \
  meanX ${workdir}/split_sumstats/${file} > ${workdir}/mean_sumstats/$file;
 echo "$file done ..."; \
 ) & \
done; wait
#wait until all processes have completed before moving on to next sub process
echo "All parallell process done for function 1"

################################################################################
# Step 3: Apply function 2
################################################################################
#list available input
avail=("$(ls ${workdir}/mean_sumstats)")


##calculate stdev of a column
#function stdevA { 
#	cat "examples/xaa" | awk '{x+=$3;y+=$3^2}END{print sqrt(y/NR-(x/NR)^2)}';
#	}
#
#
##create bash funtion to calc nr of single nucleotides
#function single_nucleotidesA { 
#	tot="$(cat "examples/xaa" | wc -l)";
#	cat "examples/xaa" | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0	] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk	-v a="${tot}" '{print $0/a, $2}'; 
#	}
#
#
##parallelisation of functions
#arr=("a" "b")
#for i in ${arr[@]}; do
#	(meanA $0; stdevA $0; single_nucleotidesA $0) > infoA.txt &
#	(meanB $1; stdevB $1; single_nucleotidesB $1) > infoB.txt &
#done
#wait
#echo "all done"
#
#
