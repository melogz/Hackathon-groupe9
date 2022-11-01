SAMPLES = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]
chro=["chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chr23","chr24"]

rule all:
    input : /counts/matrix/{sample}.txt"

rule counts:
    input:
        mapped = "/mapped/{sample}.bam",
        annot = "/downloaded_gtf/{chro}.gtf"
    output:
        counts = "/counts/matrix/{sample}.txt",
        summary = "/counts/summary/{sample}.counts.txt.summary"
    run:
        shell("docker build -f docker/Dockerfile.subread -t subread_image docker")
        for s in samples :
            shell("docker run subread_image -a {input.annot} -o {output.counts} {input.mapped}")

#featureCounts [options] -a <annotation_file> -o <output_file> input_file1