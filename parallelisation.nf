#!/usr/bin/env nextflow

params.query = "/home/kajsageorgii/Desktop/Introduction/examples/gwas_depression_test_data.txt"

query_ch = Channel.fromPath(params.query)

process divide_file {
    input:
    file gwas from query_ch

    output:
    tuple path("x000"), path("x001") into split_sumstats_ch

    """

    split -a3 -n 2 -d ${gwas}
   

    """

}


split_sumstats_ch
				.flatten()
				.map { file -> tuple(file.baseName, file) }
				.set { split_sumstats_ch_split2 }
 
process mean_dividedfiles {

	input: 
	tuple filename, path from split_sumstats_ch_split2

	output:
	tuple filename, path("${filename}") into split_sumstats_mean_ch 

	"""
	
	echo "hello" > $filename


	"""

}


	//cat ${filename} | awk '{y+=\${3}; next} END {print \${y}/NR}' > $filename 

