samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
rule star_mapping:
	input: 
		index = "data/index",
		R1 = "data/sample/{sample}.R1.fastq"
		R2 = "data/sample/{sample}.R2.fastq"
	output:"mapped_reads/{sample}.bam"
	shell:'''docker build -t STAR_img -f Dockerfile.star . ;
		docker run --name STAR_container -i -t STAR_img ;
		docker exec -it  STAR_container STAR --genomeDir {input.index} --readFilesIn {input.R1} {input.R2} --outSAMtype BAM Unsorted > {output}'''



		
	
