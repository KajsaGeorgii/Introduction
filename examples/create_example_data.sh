################################################################################
# This is how we created the example summary stats data
################################################################################

#download real sumstat file
wget ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/ShenH_31926482_GCST009978/GWAS_results_Depression.txt

#split out a sub part
cat GWAS_results_Depression.txt | head -n10000 > gwas_depression_test_data.txt



