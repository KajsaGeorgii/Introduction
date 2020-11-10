#Calculate ﻿﻿mean
cat GWAS_results_Depression.txt | awk  '{x+=$3;x2+=$6; next} END {print x/NR; print x2/NR}'

#Calculate standard deviation
﻿cat GWAS_results_Depression.txt | awk '{x+=$0;y+=$0^2}END{print sqrt(y/NR-(x/NR)^2)}'

#Calculate nucleotide frequency for single nucleotides 
﻿cat GWAS_results_Depression.txt | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n | awk '{print $0/3389130; print $2}'
