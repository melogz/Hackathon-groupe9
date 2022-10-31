FROM debian:stable-slim

MAINTAINER dobin@cshl.edu

ARG STAR_VERSION=2.7.10a

ENV PACKAGES gcc g++ make wget zlib1g-dev unzip
#gcc collection de compilateurs pour les langages de programmation, notamment Java et C
#g++ effectue le même travaille que gcc, mais ajoute également les librairies C++
#make permet de compiler facilement un gros ensemble de fichiers dans un exécutable,
#et prend en compte les modifications des fichiers
#wget telechargement de fichiers depuis le web
#zlib bibliothèque de compression
#unzip permet de désarchiver

RUN set -ex

RUN apt-get update && \
    #télécharge les listes de paquets des référentiels et les "met à jour"
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    #installe les packages de ENV
    apt-get clean && \
    #supprime la totalité des paquets présents dans /var/cache/apt/archives
    g++ --version && \
    cd /home && \
    wget --no-check-certificate https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.zip && \
    unzip ${STAR_VERSION}.zip && \
    cd STAR-${STAR_VERSION}/source && \
    make STARstatic && \
    mkdir /home/bin && \
    cp STAR /home/bin && \
    cd /home && \
    'rm' -rf STAR-${STAR_VERSION} && \
    apt-get --purge autoremove -y  ${PACKAGES}
    #remove les packages inutiles

ENV PATH /home/bin:${PATH}

