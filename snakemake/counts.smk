samples = ["SRR628582", "SRR628583", "SRR628584", "SRR628585", "SRR628586", "SRR628587", "SRR628588", "SRR628589"]

rule all:
    input : "data1/count/matrix.txt"

rule nothingHere:
    output:
        mapped = expand("data1/mapped/{sample}Aligned.out.bam", sample=samples)

rule counts:
    input:
        mapped = expand("data1/mapped/{sample}Aligned.out.bam", sample=samples)
    output:
        counts = "data1/count/matrix.txt"
    run:
        shell("docker run --volume=/tmp/Hackathon-groupe9/data1:/data1 subread_image featureCounts -p -T 16 -a data1/gencode.v24lift37.basic.annotation.gtf -o {output.counts} " + " ".join(input.mapped))

#featureCounts [options] -a <annotation_file> -o <output_file> input_file1