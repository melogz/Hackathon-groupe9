samples = "chr21"
rule all:
	input:
		expand("{sample}.fa.gz" , sample=samples)
		
rule sra:
	output: "{sample}.fa.gz"
	shell: 
		"wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr21.fa.gz"