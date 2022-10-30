import wget
url="http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/"
for i in range(24):
	i=i+1
	if i<23:
		chr_n=f"chr{i}.fa.gz"
	if i==23:
		chr_n="chrX.fa.gz"
	if i==24:
		chr_n="chrY.fa.gz"
	url_chr=f"{url}{chr_n}"
	wget.download(url_chr)	

