#!/usr/bin/env nextflow

params.query = "/home/kajsageorgii/Desktop/Introduction/examples/gwas_depression_test_data.txt"

query_ch = Channel.fromPath(params.query)

process divide_file {
    input:
    file gwas from query_ch

    output:
    tuple path("x000"), path("x001") into split_sumstats

    """

    split -a3 -n 2 -d ${gwas}
   

    """

}
