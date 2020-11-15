#catch forst variable in $1
infile=$1

#make results folder (-p flag means that it should not be recreated if already exists)
mkdir -p results

#Calculate mean
cat ${infile} | awk  '{x+=$3;x2+=$6; next} END {print x/NR; print x2/NR}' > results/mean.res

#Calculate standard deviation
cat ${infile} | awk '{x+=$0;y+=$0^2}END{print sqrt(y/NR-(x/NR)^2)}' > results/sd.res

#Calculate nucleotide frequency for single nucleotides 
cat ${infile} | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk '{print $0/3389130; print $2}' > results/nucfreq.res


# tell user script completed
echo "script has completed for: ${infile}"

