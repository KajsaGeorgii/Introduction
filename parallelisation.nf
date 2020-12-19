#!/usr/bin/env nextflow

params.query = "examples/gwas_depression_test_data.txt"

query_ch = Channel.fromPath(params.query)

process divide_file {
    input:
    file gwas from query_ch

    output:
    tuple path("x000"), path("x001") into split_sumstats_ch

    """
     tail -n+2 ${gwas} > removedheader
     split -a3 -n l/2 -d removedheader
   

    """

}


split_sumstats_ch
	.flatten()
	.map { file -> tuple(file.baseName, file) }
	.set { split_sumstats_ch_split2 }
 
process mean_dividedfiles {
        publishDir "my_results"

	publishDir 'my_results'

	input: 
	tuple filename, path from split_sumstats_ch_split2

	output:
	tuple filename, path("${filename}_mean") into split_sumstats_mean_ch 

	"""

	cat ${path} | awk '{y+=\$3; next}; END {print y/NR}' > ${filename}_mean


	"""
}


//split_sumstats_mean_ch
//	.collectFile(name: 'meanofgwas.txt', newLine: true)
//	.view { it.text }

