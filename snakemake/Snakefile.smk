SAMPLES = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
chro=["chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY"]
rule all:
    input: "/result/analyse_stat"

rule SRA_download_fastq: 
    output:"/downloaded_fastq/{sample}.fq"
    run:

rule SRA_download_genome:
    output:"/downloaded_genome/{chro}.fa"
    shell: "python script.py"

rule SRA_download_gtf:
    output:"/downloaded_gtf/{chro}.gtf"
    run:


rule STAR_index:
    input:
        gene = "/downloaded_genome/{chro}.fa",
        annot = "/downloaded_gtf/{chro}.gtf"
    output: "/index/{chro}"
    run:

rule STAR_mapping:
    input:
        index = "/index/{chro}",
        ressources = "/downloaded_fastq/{sample}.fq"
    output:"/mapped/{sample}.bam"
    run:

rule FEATURE_counting:
    input:
        mapped = "/mapped/{sample}.bam",
        annot = "/downloaded_gtf/{chro}.gtf"
    output:
        counts = "/counts/matrix/{sample}.txt",
        summary = "/counts/summary/{sample}.counts.txt.summary"
    run:

rule DESeq:
    input: expand("/counts/matrix/{sample}.txt",sample=SAMPLES)
    output: "/result/analyse_stat"
    run:
