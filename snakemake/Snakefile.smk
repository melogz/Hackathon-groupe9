samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]

rule all:
    input: "/result/analyse_stat"

rule SRA_download_fastq:
    input: 
    output:"/downloaded_fastq/{}"
    run:

rule SRA_download_genome:
    input:
    output:"/downloaded_genome/{}"
    run: "python script.py"

rule SRA_download_gft:
    input:
    output:"/downloaded_gft/{}"
    run:

rule STAR_mapping:
    input:
    output:"/mapped/{}"
    run:

rule STAR_index:
    input:
    output: "/index/{}"
    run:

rule FEATURE_counting:
    input:
    output:"/counts/matrix/{}"
    run:

rule DESeq:
    input: "/counts/matrix/{}"
    output: "/result/analyse_stat"
    run: