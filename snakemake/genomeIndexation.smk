#samples = ["chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY"]
#samples = ["chr"+str(i) for i in range(1,23)] + ["chrX", "chrY"]
samples = ["chr21", "chrX"]
rule all:
	input:
		"data/gendir/hello.txt"
		
rule downloadChr:
	output: "data/{sample}.fa"
	shell:"""
            mkdir -p data
            mkdir -p data/gendir
            wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/{wildcards.sample}.fa.gz
            gunzip {wildcards.sample}.fa.gz
            mv {wildcards.sample}.fa data
        """

rule downloadGtf:
    output: "data/gencode.v24lift37.basic.annotation.gtf"
    shell:"""
            wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_24/GRCh37_mapping/gencode.v24lift37.basic.annotation.gtf.gz
            gunzip gencode.v24lift37.basic.annotation.gtf.gz
            mv gencode.v24lift37.basic.annotation.gtf data
    """

rule star:
    input: expand("data/{sample}.fa", sample=samples) + ["data/gencode.v24lift37.basic.annotation.gtf"]
    output: "data/gendir/hello.txt"
    threads: 8
    shell:"""docker run --volume=/tmp/Hackathon-groupe9/data:/data -t img_star STAR --runMode genomeGenerate --runThreadN 8 \
            --genomeDir data/gendir \
            --genomeFastaFiles data/chr*.fa \
            --sjdbGTFfile data/gencode.v24lift37.basic.annotation.gtf
            echo 'hello world' > data/gendir/hello.txt"""