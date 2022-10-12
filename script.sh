#!/bin/sh

V=3.0.0

if [ "$UID" = "" ]
then
    UID=$(id -u)
fi

if [ $UID -ne 0 ]
then
    sudo /bin/sh $0 $* && exit $?
    echo "please run with sudo"
    exit 1
fi

# install perl and dependencies
apt-get --quiet install --yes libxml-libxml-perl

echo "installing sra toolkit to /usr/local/ncbi"
rm -rf .ncbi /usr/local/ncbi /etc/ncbi /etc/profile.d/sra-tools* # remove old install if any

curl https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/$V/sratoolkit.$V-centos_linux64-cloud.tar.gz | tar xz -C /
if [ $? -ne 0 ]
then
    echo failure
    exit 1
fi

echo "Please 'source /etc/profile.d/sra-tools.sh' to setup your path"