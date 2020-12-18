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
avail=("$(ls ${workdir}/split_sumstats)")

#make work directory sub folder for this process
mkdir -p ${workdir}/stdev_sumstats

#calculate stdev of a column
function stdevX {
  cat "${1}" | awk '{x+=$3;y+=$3^2}END{print sqrt(y/NR-(x/NR)^2)}';
}

# Start the different parallell processes
for file in ${avail[@]}; do \
 ( \
 echo "$file starting ..."; \
  stdevX ${workdir}/split_sumstats/${file} > ${workdir}/stdev_sumstats/$file;
 echo "$file done ..."; \
 ) & \
done; wait
#wait until all processes have completed before moving on to next sub process
echo "All parallell process done for function 2"


################################################################################
# Step 4: Apply function 3
################################################################################

#list available input
avail=("$(ls ${workdir}/split_sumstats)")

#make work directory sub folder for this process
mkdir -p ${workdir}/nucleotides_sumstats

#calculate stdev of a column
function nucleotidesX { 
       tot="$(cat "${1}" | wc -l)";
       cat "${1}" | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0    ] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk -v a="${tot}" '{print $0/a, $2}'; 
       }



# Start the different parallell processes
for file in ${avail[@]}; do \
 ( \
 echo "$file starting ..."; \
  nucleotidesX ${workdir}/split_sumstats/${file} > ${workdir}/nucleotides_sumstats/$file;
 echo "$file done ..."; \
 ) & \
done; wait
#wait until all processes have completed before moving on to next sub process
echo "All parallell process done for function 3"

################################################################################
# Step 5: Summarize the data
################################################################################

#list available input
avail=("$(ls ${workdir}/split_sumstats)")

#make work directory sub folder for this process
mkdir -p ${workdir}/summarized_sumstats

#summarize the mean stats
cat ${workdir}/mean_sumstats/* | awk '{x+=$1; next} END {print x/NR}' > ${workdir}/summarized_sumstats/sum_mean

#summarize the stdev stats
cat ${workdir}/stdev_sumstats/* | awk '{x+=$1;y+=$1^2}END{print sqrt(y/NR-(x/NR)^2)}' > ${workdir}/summarized_sumstats/sum_stdev

#summarize the nucleotide stats (exhange the "/2" depending on the number of parts the file is divided into)
cat ${workdir}/nucleotides_sumstats/* | awk '{ seen[$2] += $1 } END { for (i in seen) print seen[i]/2,i }' > ${workdir}/summarized_sumstats/sum_nucleotides

echo "The final output for mean, stdev and single nucleotide frequency for the whole GWAS file can be found in the folder: summarized_sumstats."
echo "THE SCRIPT IS DONE."


