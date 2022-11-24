samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]

rule all:
	input:
		expand("data1/mapped_reads/{sample}Aligned.out.bam", sample=samples)

rule nothingHere:
	output: expand("data1/fastqFiles/{sample}_1.fastq", sample=samples) + expand("data1/fastqFiles/{sample}_2.fastq", sample=samples)

rule star_mapping:
	threads: 16
	input:
		R1 = "data1/fastqFiles/{sample}_1.fastq",
		R2 = "data1/fastqFiles/{sample}_2.fastq",
	output:"data1/mapped_reads/{sample}Aligned.out.bam"
	shell:'''docker run --volume=/tmp/Hackathon-groupe9/data1:/data1 -t img_star \
		STAR --runThreadN 16 --genomeDir data1/gendir --readFilesIn {input.R1} {input.R2} \
		--outSAMtype BAM Unsorted --outFileNamePrefix data1/mapped_reads/{wildcards.sample}'''



		
	
