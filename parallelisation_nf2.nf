nextflow.enable.dsl=2

process divide_file {
    
    input:
    path x

    output:
    tuple path("x000"), path("x001")

    script:
    """
     tail -n+2 ${x} > removedheader
     split -a3 -n l/2 -d removedheader 
    """
}


process mean_dividedfiles {

        input:
	tuple val(filename), file(path)

        output: 
        tuple val(filename), file("${filename}_mean")

	script:
        """
        cat ${path} | awk '{y+=\$3; next}; END {print y/NR}' > ${filename}_mean
        """
}


process join_mean_dividedfiles {


	input:
	path means

	output:
	path "final_mean"

	"""
        for mean in ${means}
        do
          cat \$mean >> means2
        done
        cat means2 | awk '{y+=\$1; next}; END {print y/NR}' > final_mean
	"""
}

workflow {
        main:
	data = channel.fromPath("examples/gwas_depression_test_data.txt")        
	divide_file(data)


	divide_file.out
		.flatten()
		.map { file -> tuple(file.baseName, file) }
                .set{ split_sumstats_ch }
			

	mean_dividedfiles(split_sumstats_ch) 

	mean_dividedfiles.out
        	.map {filename, file -> file }
		.collect()
        	.set{ collected_file_ch }
	
	join_mean_dividedfiles(collected_file_ch)
	
	join_mean_dividedfiles.out.view()

}

