docker build -f docker/Dockerfile.fastqdump -t fastqdump_image docker
docker run --volume=/tmp/Hackathon-groupe9/data:/data -t -d --name running fastqdump_image
docker exec -d running bash -c "source usr/local/inExec.sh"
docker exec -it running fastq-dump --help

# Usage : docker exec -it running fastq-dump --stdout [SRR_id] > fastq/[SRR_id].fastq