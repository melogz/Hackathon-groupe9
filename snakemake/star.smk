samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
rule star_mapping:
	input: 
		index = "data/index",
		fastq = "data/sample/{sample}.fastq"
	output:
		"mapped_reads/{sample}.bam"
	shell:
		STAR --genomeDir index --readFilesIn fastq



		
	