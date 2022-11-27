#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("DESeq2")
#BiocManager::install("S4Vectors")
#install.packages("stringr")
library(S4Vectors)
library(DESeq2)
library(stringr)
#install.packages("ggplot2")
library(ggplot2)
library(MASS)
#install.packages("calibrate")
library(calibrate)
library(gplots)
library(RColorBrewer)
#BiocManager::install("ComplexHeatmap")
library(ComplexHeatmap)

matrix_brut_gene=read.table("countmatrixWithout_p.txt")
matrix_brut=read.table("matrix.txt")


data_gene=cbind(matrix_brut_gene$V7,matrix_brut_gene$V8,matrix_brut_gene$V9,matrix_brut_gene$V14,matrix_brut_gene$V10,
           matrix_brut_gene$V11,matrix_brut_gene$V12,matrix_brut_gene$V13)
##
#Séléction des colonnes ayant un interêt
##
data=cbind(matrix_brut$V7,matrix_brut$V8,matrix_brut$V9,matrix_brut$V14,matrix_brut$V10,
           matrix_brut$V11,matrix_brut$V12,matrix_brut$V13)
##
#Mise en forme du dataframe
##
data=data_gene
names_col=data[1,]
data=data[-1,]
rownames(data)=matrix_brut_gene$V1[-1]
names_col=str_sub(names_col, start = 13L, end = 22L) 
colnames(data)=names_col

data=data.frame(data)
##
#convertion chr --> int
##
data$SRR628582A=as.integer(data$SRR628582A)
data$SRR628583A=as.integer(data$SRR628583A)
data$SRR628584A=as.integer(data$SRR628584A)
data$SRR628589A=as.integer(data$SRR628589A)
data$SRR628585A=as.integer(data$SRR628585A)
data$SRR628586A=as.integer(data$SRR628586A)
data$SRR628587A=as.integer(data$SRR628587A)
data$SRR628588A=as.integer(data$SRR628588A)


cond<-factor(c("MT","MT","MT","MT","WT","WT","WT","WT"))
colData=data.frame(condition=cond)

dds <- DESeqDataSetFromMatrix(countData = data, 
                              colData = colData,
                              design = ~ condition)
dds <- DESeq(dds, test="LRT", reduced = ~1)
dds_res <- results(dds)
#summary(dds_res)

#On ordonne en fonction des pvalue adjusted
dds_res <- dds_res[order(dds_res$padj),]

hist(dds_res$pvalue) #on cherche à voir les gène avec une petite p-value ainsi que lels gène qui sont différentielles
#On regarde si homogène ou non
# Dans le cas d'absence de plateau on a une preuve de  ariabilité qui montre une erreur dans une étape de l'analyse

## analyse de la dispersion des reads
plotDispEsts(dds, main="Dispersion plot")

test=dds_res[complete.cases(dds_res), ]
test=data.frame(test)
ggplot(data=test, aes(x=log2FoldChange, y=pvalue)) + geom_point()
#abline(h=0.5, col="red")

r_log_dds <- rlogTransformation(dds)
#head(assay(r_log_dds))
hist(assay(r_log_dds))


mycolors <- brewer.pal(8, "Greens")[1:length(unique(cond))]
sampleDists <- as.matrix(dist(t(assay(r_log_dds))))

heatmap.2(as.matrix(sampleDists), key=F, trace="none",
          col=colorpanel(100, "blue", "red"),
          ColSideColors=mycols[cond], RowSideColors=mycols[cond],
          margin=c(10, 10), main="Sample Distance Matrix")

my_group=cbind(cond)
colnames(my_group)=c("Type")
my_group=data.frame(my_group)

colors <- c("red","green")
names(colors)<-c("1","2")
colors<-list('Type' = c('1' = 'cyan', '2' = 'red'))

colAnn <- HeatmapAnnotation(df = my_group ,col = colors,which = 'col')
rowAnn <- HeatmapAnnotation(df = my_group ,col = colors,which = 'row')
Heatmap(as.matrix(sampleDists),column_title ="Sample Distance Matrix",
        cluster_rows = TRUE,cluster_columns = TRUE,
        cluster_row_slices = TRUE,cluster_column_slices =TRUE,
        col = colorRampPalette(brewer.pal(8, "RdYlBu"))(25),column_labels = colnames(sampleDists),row_km = 1,column_km = 1,top_annotation = colAnn, left_annotation = rowAnn)



p_adj=c()
log2_change=c()
id_Gene=c()
name_row=rownames(test)
for (i in 1:nrow(test)){
  if (test$padj[i]<=0.05){
    p_adj=c(p_adj,test$padj[i])
    log2_change=c(log2_change,test$log2FoldChange[i])
    id_Gene=c(id_Gene,name_row[i])
  }
  cat(i,"\t")
}  
#length(p_adj)
#length(log2_change)
#length(id_Gene)
table(dds_res$padj<=0.05)

gene_DE = cbind(log2_change,p_adj)
rownames(gene_DE)=id_Gene
gene_DE=data.frame(gene_DE)


volcanoplot <- function (res, lfcthresh=2, sigthresh=0.05, main="Volcano Plot", legendpos="topleft", labelsig=FALSE, textcx=1, Stock =TRUE ,...) {
  #with(res, plot(log2FoldChange, padj, pch=20, main=main, ...))
  with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
  with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
  with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="orange", ...))
  with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="green", ...))
  if (labelsig) { #FALSE donc pas de nom de génes dans le plot
    require(calibrate)
    with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), textxy(log2FoldChange, -log10(pvalue), labs=Gene, cex=textcx, ...))
  }
  if (Stock){
    volcano_Gene_threshold <- subset(res, padj<thresh)[,1] # je ne garde que la premiére colonne , donc les noms de génes.
  }
  legend(legendpos, xjust=1, yjust=1, legend=c(paste("FDR<",sigthresh,sep=""), paste("|LogFC|>",lfcthresh,sep=""), "both"), pch=20, col=c("red","orange","green"))
}

volcanoplot(dds_res, lfcthresh=1, sigthresh=0.05, textcx=.8, xlim=c(-4.3, 2))
abline(h=0.05,col="red")
#####
#
#####
#
###Suppression des id sans read associé

#data_NA=data
#compteur=0
#for (i in 1:nrow(data)){
#  if (rowSums(data[i,])==0){
#    data_NA=data_NA[-(i-compteur),]
#    compteur=compteur+1
#    cat(i,"\t")
#  }
#}

###Normalisation

#data_norm_NA=data_NA
#for (j in 1:ncol(data_norm_NA)){
#  cat(j,"\t")
#  for (i in 1:nrow(data_norm_NA)){
#    data_norm_NA[i,j]=data_norm_NA[i,j]/colSums(data_NA[j])
#  }
#}
#pvalue=c()
#for (i in 1:ncol(data_norm_NA)){
#  stat=t.test(data_norm_NA[1:4,i],data_norm_NA[5:8,i])
#  pvalue= c(pvalue,stat$p.value)
#}

#dds2 <- DESeqDataSetFromMatrix(countData = data_NA, 
#                              colData = colData,
#                              design = ~ condition)
#dds2 <- DESeq(dds2, test="LRT", reduced = ~1)
#dds2_res <- results(dds2)
#summary(dds2_res)
#hist(dds2_res$pvalue)


#data_norm_log2=log2(data_norm + 0.5)

data_NA_log2=log2(data_NA + 0.5)
#ggplot(data=data_NA, aes(x=log2FoldChange, y=pvalue)) + geom_point()

ggplot(data=data_NA_log2)
