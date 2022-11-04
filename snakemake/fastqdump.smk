samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
rule all:
	input:
		expand("data/fastqFiles/{sample}.fastq" , sample=samples)
		
rule processing_step:
	output: "data/fastqFiles/{sample}.fastq"
	run:
		shell("mkdir -p data")
		shell("mkdir -p data/fastqFiles")
		for s in samples:
			shell("docker exec -it running fastq-dump -X 100 --stdout {s} > data/fastqFiles/{s}.fastq")
