docker build -f docker/Dockerfile.fastqdump -t fastqdump_image docker
docker run -t -d --name running fastqdump_image
docker exec -d running bash -c "source usr/local/inExec.sh"
docker exec -it running fastq-dump --help

# Usage : docker exec -it running fastq-dump --stdout -X 2 ${SRRID} >> 