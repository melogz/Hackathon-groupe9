# base image: Ubuntu
FROM ubuntu:22.04
RUN apt-get update --fix-missing \
&& apt-get install -y wget \
&& cd /usr/local/ \
&& wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz \
&& tar -xvzf sratoolkit.3.0.0-ubuntu64.tar.gz \
&& rm -rf sratoolkit.3.0.0-ubuntu64.tar.gz \
&& export PATH=$PATH:$PWD/sratoolkit.3.0.0-ubuntu64/bin
ENTRYPOINT ["/usr/local"]