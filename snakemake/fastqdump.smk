samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
rule all:
	input:
		expand("data1/fastqFiles/{sample}_1.fastq" , sample=samples) + expand("data1/fastqFiles/{sample}_2.fastq" , sample=samples)
		
rule processing_step:
	output: "data1/fastqFiles/{sample}_1.fastq", "data1/fastqFiles/{sample}_2.fastq"
	run:
		shell("mkdir -p data1")
		shell("mkdir -p data1/fastqFiles")
		shell("docker exec -it running fastq-dump -O data1/fastqFiles {wildcards.sample} --split-files")
