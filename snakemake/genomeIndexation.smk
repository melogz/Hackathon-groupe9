samples = "chr21"
rule all:
	input:
		expand("data/gendir{sample}/hello.txt", sample=samples)
		
rule download:
	output: "data/{sample}.fa"
	shell:"""
            mkdir -p data
            mkdir -p data/gendir{wildcards.sample}
            wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr21.fa.gz
            wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_24/GRCh37_mapping/gencode.v24lift37.basic.annotation.gtf.gz
            gunzip chr21.fa.gz
            gunzip gencode.v24lift37.basic.annotation.gtf.gz
            mv chr21.fa data
            mv gencode.v24lift37.basic.annotation.gtf data
        """

rule star:
    input: "data/{sample}.fa"
    output: "data/gendir{sample}/hello.txt"
    threads: 2
    shell:"""docker run --volume=/tmp/Hackathon-groupe9/data:/data -t img_star STAR --runMode genomeGenerate --runThreadN 2 \
            --genomeDir data/gendir{wildcards.sample} \
            --genomeFastaFiles data/{wildcards.sample}.fa \
            --sjdbGTFfile data/gencode.v24lift37.basic.annotation.gtf
            echo 'hello world' > data/gendir{wildcards.sample}/hello.txt"""