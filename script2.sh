#create bash funtion to calc nr of single nucleotides
function single_nucleotides { 
  echo "Input file:"; 
  read file; 
  local var=$(cat $file | awk '{print $4}' | grep '^.$' | awk  '{ seen[$0] += 1 } END { for (i in seen) print seen[i],i }' | sort -k2,2 -n);
  local var2=$(echo "$var" | cut -d" " -f 1);
  local var3=$(cat $file | wc -l);
  local var4=$(while IFS= read -r line; do echo $((line / var3)); done <<< "$var2");
  local var5=$(echo "$var" | cut -d" " -f 2); 
  awk -v a="$var4" -v b="$var5" 'BEGIN {print a,b}';

}
