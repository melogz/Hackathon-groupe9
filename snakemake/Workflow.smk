chromosomes = ["chr"+str(i) for i in range(1,23)] + ["chrX", "chrY"]
samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]

rule all:
	input:
		"data/count/matrix.txt"
		
rule downloadChr:
	output: "data/{chromosome}.fa"
	shell:"""
            mkdir -p data
            mkdir -p data/gendir
            wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/{wildcards.chromosome}.fa.gz
            gunzip {wildcards.chromosome}.fa.gz
            mv {wildcards.chromosome}.fa data
        """

rule downloadGtf:
    output: "data/gencode.v24lift37.basic.annotation.gtf"
    shell:"""
            wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_24/GRCh37_mapping/gencode.v24lift37.basic.annotation.gtf.gz
            gunzip gencode.v24lift37.basic.annotation.gtf.gz
            mv gencode.v24lift37.basic.annotation.gtf data
    """

rule star:
    input: expand("data/{chromosome}.fa", chromosome=chromosomes) + ["data/gencode.v24lift37.basic.annotation.gtf"]
    output: "data/gendir/hello.txt"
    threads: 16
    shell:"""docker run --volume=/tmp/Hackathon-groupe9/data:/data -t img_star STAR --runMode genomeGenerate --runThreadN 16 \
            --genomeDir data/gendir \
            --genomeFastaFiles data/chr*.fa \
            --sjdbGTFfile data/gencode.v24lift37.basic.annotation.gtf
            echo 'hello world' > data/gendir/hello.txt"""

rule fastqDump:
	output: "data/fastqFiles/{sample}_1.fastq", "data/fastqFiles/{sample}_2.fastq"
	run:
		shell("mkdir -p data")
		shell("mkdir -p data/fastqFiles")
		shell("docker exec -it running fastq-dump -O data/fastqFiles {wildcards.sample} --split-files")

rule mapping:
	threads: 2
	input:"data/gendir/hello.txt", R1 = "data/fastqFiles/{sample}_1.fastq", R2 = "data/fastqFiles/{sample}_2.fastq",

	output:"data/mapped/{sample}Aligned.out.bam"
	shell:'''docker run --volume=/tmp/Hackathon-groupe9/data:/data -t img_star \
		STAR --runThreadN 2 --genomeDir data/gendir --readFilesIn {input.R1} {input.R2} \
		--outSAMtype BAM Unsorted --outFileNamePrefix data/mapped/{wildcards.sample}'''

rule counts:
    input:
        mapped = expand("data/mapped/{sample}Aligned.out.bam", sample=samples)
    output:
        counts = "data/count/matrix.txt"
    threads: 16
    run:
        shell("docker run --volume=/tmp/Hackathon-groupe9/data:/data subread_image featureCounts -p -T 16 -a data/gencode.v24lift37.basic.annotation.gtf -o {output.counts} " + " ".join(input.mapped))
