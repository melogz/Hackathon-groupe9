# base image: Ubuntu
<<<<<<< HEAD
FROM ubuntu:22.04

ENV PATH=$PATH:$PWD/sratoolkit.3.0.0-ubuntu64/bin

RUN apt-get update --fix-missing \
&& apt-get install -y wget \
&& cd /usr/local/ \
&& wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz \
&& tar -xvzf sratoolkit.3.0.0-ubuntu64.tar.gz \
&& rm -rf sratoolkit.3.0.0-ubuntu64.tar.gz \
ENTRYPOINT ["/usr/local/sratoolkit.3.0.0-ubuntu64/bin/fatsq-dump"]
=======
FROM rocker/r-base:latest
## create directories
RUN mkdir -p /01_data
RUN mkdir -p /02_code
RUN mkdir -p /03_output
## copy files
COPY /02_code/install_packages.R /02_code/install_packages.R
## install R-packages
RUN Rscript /02_code/install_packages.R
>>>>>>> axel_random
