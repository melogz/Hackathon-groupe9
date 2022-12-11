#!/bin/bash
for (( c=1; c<=24; c++ ))
do  
  chrn=$(echo "chr$c")
  if [[ "$c" == '23' ]]
  then
    chrn=$(echo "chrX")
    wget "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/${chrn}.fa.gz"
  fi
  if [[ "$c" == '24' ]]
  then
    chrn=$(echo "chrY")
    wget "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/${chrn}.fa.gz"
  fi
  echo "$chrn"
  
done
