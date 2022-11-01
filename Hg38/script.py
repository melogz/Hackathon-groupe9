import wget
import os

def checkFileExistance(filePath):
    try:
        with open(filePath, 'r') as f:
            return True
    except FileNotFoundError as e:
        return False
    except IOError as e:
        return False

url="http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/"
for i in range(24):
	i=i+1
	if i<23:
		chr_n=f"chr{i}.fa.gz"
		url_chr=f"{url}{chr_n}"
		path_chr = './genome/chr'+str(i)+'.fa.gz'
		if not checkFileExistance(path_chr):
			wget.download(url_chr, './genome')
	if i==23:
		chr_n="chrX.fa.gz"
		url_chr=f"{url}{chr_n}"
		if not checkFileExistance('./genome/chrX.fa.gz'):
			wget.download(url_chr, './genome')
	if i==24:
		chr_n="chrY.fa.gz"
		url_chr=f"{url}{chr_n}"
		if not checkFileExistance('./genome/chrY.fa.gz'):
			wget.download(url_chr, './genome')
		

