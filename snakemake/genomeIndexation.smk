#samples = ["chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY"]
samples = ["chr"+str(i) for i in range(1,23)] + ["chrX", "chrY"]
#samples = ["chr21", "chrX"]
rule all:
	input:
		"data1/gendir/hello.txt"
		
rule downloadChr:
	output: "data1/{sample}.fa"
	shell:"""
            mkdir -p data1
            mkdir -p data1/gendir
            wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/{wildcards.sample}.fa.gz
            gunzip {wildcards.sample}.fa.gz
            mv {wildcards.sample}.fa data1
        """

rule downloadGtf:
    output: "data1/gencode.v24lift37.basic.annotation.gtf"
    shell:"""
            wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_24/GRCh37_mapping/gencode.v24lift37.basic.annotation.gtf.gz
            gunzip gencode.v24lift37.basic.annotation.gtf.gz
            mv gencode.v24lift37.basic.annotation.gtf data1
    """

rule star:
    input: expand("data1/{sample}.fa", sample=samples) + ["data1/gencode.v24lift37.basic.annotation.gtf"]
    output: "data1/gendir/hello.txt"
    threads: 16
    shell:"""docker run --volume=/tmp/Hackathon-groupe9/data1:/data1 -t img_star STAR --runMode genomeGenerate --runThreadN 16 \
            --genomeDir data1/gendir \
            --genomeFastaFiles data1/chr*.fa \
            --sjdbGTFfile data1/gencode.v24lift37.basic.annotation.gtf
            echo 'hello world' > data1/gendir/hello.txt"""