samples = ["chr"+str(i) for i in range(1,23)] + ["chrX", "chrY"]
fastas = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
rule all:
	input:
		"data/gendir/Mapping.txt"
		
rule processing_step:
	output: "data1/fastqFiles/{fasta}_1.fastq", "data1/fastqFiles/{fasta}_2.fastq"
	run:
		shell("mkdir -p data1")
		shell("mkdir -p data1/fastqFiles")
		shell("docker exec -it running fastq-dump -O data1/fastqFiles {wildcards.fasta} --split-files")
			
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
            echo 'hello world' > data/gendir/hello.txt"""samples = ["chr"+str(i) for i in range(1,23)] + ["chrX", "chrY"]
		
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
            echo 'indexation' > data/gendir/hello.txt
            """

rule star_mapping:
	threads: 16
	input:
		R1 = "data1/fastqFiles/{sample}_1.fastq",
		R2 = "data1/fastqFiles/{sample}_2.fastq",
	output:"data1/mapped_reads/{sample}Aligned.out.bam"
	shell:"""docker run --volume=/tmp/Hackathon-groupe9/data1:/data1 -t img_star \
		STAR --runThreadN 16 --genomeDir data1/gendir --readFilesIn {input.R1} {input.R2} \
		--outSAMtype BAM Unsorted --outFileNamePrefix data1/mapped_reads/{wildcards.sample}
		echo 'Mapping' > data/gendir/Mapping.txt"""


            
