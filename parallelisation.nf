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

	input: 
	tuple filename, path from split_sumstats_ch_split2

	output:
	tuple filename, file("${filename}_mean") into split_sumstats_mean_ch 

	"""
	cat ${path} | awk '{y+=\$3; next}; END {print y/NR}' > ${filename}_mean
	"""
}

// Docs about how to collect a file
// https://www.nextflow.io/docs/latest/faq.html#how-do-i-iterate-over-nth-files-from-within-a-process
// https://www.nextflow.io/docs/latest/operator.html#collect

split_sumstats_mean_ch
        .map {filename, file -> file }
	.collect()
        .set{collected_file_ch}

process join_mean_dividedfiles {

	publishDir "my_results"

	input:
	file means from collected_file_ch

	output:
	stdout into result
	file('final_mean') into last_ch

	"""
        for mean in ${means}
        do
          cat \$mean >> means2
          cat \$mean
        done
        cat means2 | awk '{y+=\$1; next}; END {print y/NR}' > final_mean
        echo -e "final mean: "
        cat final_mean
	"""
} 

result.view{ it.trim() }



