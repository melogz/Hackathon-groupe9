library(S4Vectors)
library(DESeq2)
library(stringr)

library(ggplot2)
library(MASS)

library(calibrate)
library(gplots)
library(RColorBrewer)

library(ComplexHeatmap)

library(limma)

library(edgeR)

library(biomaRt)

library("FactoMineR")


matrix_brut_gene=read.table("countmatrixWithout_p.txt")


data_gene=cbind(matrix_brut_gene$V7,matrix_brut_gene$V8,matrix_brut_gene$V9,matrix_brut_gene$V14,matrix_brut_gene$V10,
           matrix_brut_gene$V11,matrix_brut_gene$V12,matrix_brut_gene$V13)
##
#Séléction des colonnes ayant un interêt
##
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


###Suppression des id sans read associé

###Faire une moyenne pour chaque ligne et appliqué un filtre selon le seuil choisit d'expression basale.
##regarder figure potentiel sur ncbi (ou on a télécharger les donées)

data_NA=data[-which(rowSums(data)<8),]

data_NA_cpm = cpm(data_NA)
data_NA_cpm_log= log2(data_NA_cpm + 0.5)

cond<-factor(c("MT","MT","MT","MT","WT","WT","WT","WT"))
colData=data.frame(condition=cond)


dds <- DESeqDataSetFromMatrix(countData = data, 
                              colData = colData,
                              design = ~ condition)
dds <- DESeq(dds, test="LRT", reduced = ~1)
dds_res <- results(dds)

dds_NA <- DESeqDataSetFromMatrix(countData = data_NA, 
                                 colData = colData,
                                 design = ~ condition)
dds_NA <- DESeq(dds_NA, test="LRT", reduced = ~1)
dds_NA_res <- results(dds_NA)

png("Histogram_pvalue_without_filter.png", w=480, h=480, pointsize=12)
hist(dds_res$pvalue, main="histogram of pvalue without filter",xlab="pvalue")
dev.off()
png("Histogram_pvalue_with_filter.png", w=480, h=480, pointsize=12)
hist(dds_NA_res$pvalue,main="histogram of pvalue with filter",xlab="pvalue")
dev.off()
#on cherche à voir les gène avec une petite p-value ainsi que lels gène qui sont différentielles
#On regarde si homogène ou non
# Dans le cas d'absence de plateau on a une preuve de  ariabilité qui montre une erreur dans une étape de l'analyse


maplot <- function (res, seuil=0.05, labelsig=FALSE,...) {
  with(res, plot(baseMean, log2FoldChange, pch=1, cex=.5, log="x", ...))
  with(subset(res, padj<seuil), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
}

png("MAplot.png", w=480, h=480, pointsize=12)
maplot(dds_NA_res, main="MA Plot")
dev.off()

#même fonction mais on ajuste l'axe des y pour exclure les outliers

maplot <- function (res, seuil=0.05, labelsig=FALSE,...) {
  with(res, plot(baseMean, log2FoldChange, pch=1, cex=.5, log="x",ylim=c(-7,7), ...))
  with(subset(res, padj<seuil), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
}

png("MAplot_zoom.png", w=480, h=480, pointsize=12)
maplot(dds_NA_res, main="MA Plot")
dev.off()

table(dds_NA_res$padj<=0.05)

#On ordonne en fonction des pvalue adjusted
dds_res <- dds_res[order(dds_res$padj),]
dds_NA_res <- dds_NA_res[order(dds_NA_res$padj),]
gene_DE=cbind(rownames(dds_NA_res)[which(dds_NA_res$padj <= 0.05)],dds_NA_res$padj[which(dds_NA_res$padj <= 0.05)])


#suppression des versions
gene_DE[,1]=gsub('[.]{1}[0-9]+[_]{1}[A-Z]+|[.]{1}[0-9]+|[.]{1}[0-9]+[_]{1}[A-Z]+[_]{1}[A-Z]+','',gene_DE[,1])

gene_DE=data.frame(gene_DE)
colnames(gene_DE)=c("feature","padj")

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
biomart1<-getBM(filters= "ensembl_gene_id", attributes= c("ensembl_gene_id","hgnc_symbol"),values = gene_DE, mart= mart,useCache = F )

colnames(biomart1)=c("feature","hgnc_symbol")
biomart1$hgnc_symbol[duplicated(biomart1$hgnc_symbol)]

#suppression des champs vides
j = nrow(biomart1)
compteur = 1
i=1
while (i < j+1){
  if (biomart1$hgnc_symbol[compteur]==""){
    biomart1=biomart1[-compteur,]
    compteur=compteur-1
  }
  i = i+1
  compteur=compteur+1
}
biomart1$hgnc_symbol[duplicated(biomart1$hgnc_symbol)]
data2=merge(biomart1,gene_DE,by="feature",all.x=TRUE,all.y=FALSE)

rownames(data_NA_cpm_log)=gsub('[.]{1}[0-9]+[_]{1}[A-Z]+|[.]{1}[0-9]+|[.]{1}[0-9]+[_]{1}[A-Z]+[_]{1}[A-Z]+','',rownames(data_NA_cpm_log))

tumor1=c()
tumor2=c()
tumor3=c()
tumor4=c()
normal1=c()
normal2=c()
normal3=c()
normal4=c()

#on ordonne en fonction des padj
#data2=data.frame(data2)
#data2$padj=as.numeric(data2$padj)
#data2 <- data2[order(data2$padj),]
for (i in 1:nrow(data2)){
  for (j in 1:nrow(data_NA_cpm_log)){
    if (data2[i,1]==rownames(data_NA_cpm_log)[j]){
    tumor1=c(tumor1,data_NA_cpm_log[j,1])
    tumor2=c(tumor2,data_NA_cpm_log[j,2])
    tumor3=c(tumor3,data_NA_cpm_log[j,3])
    tumor4=c(tumor4,data_NA_cpm_log[j,4])
    normal1=c(normal1,data_NA_cpm_log[j,5])
    normal2=c(normal2,data_NA_cpm_log[j,6])
    normal3=c(normal3,data_NA_cpm_log[j,7])
    normal4=c(normal4,data_NA_cpm_log[j,8])
    
    }
  }
  cat(i,"/",nrow(data2),"\t")
}
#
## Relier id gene avec pvalue
#
gene_DE_matrix = cbind(tumor1,tumor2,tumor3,tumor4,normal1,normal2,normal3,normal4,data2$padj)

rownames(gene_DE_matrix)=data2$hgnc_symbol

gene_DE_matrix=data.frame(gene_DE_matrix)
gene_DE_matrix$V9=as.numeric(gene_DE_matrix$V9)

gene_DE_matrix <- gene_DE_matrix[order(gene_DE_matrix$V9),]
gene_DE_matrix_adj=data.frame(gene_DE_matrix$V9)
rownames(gene_DE_matrix_adj)=rownames(gene_DE_matrix)
gene_DE_matrix$tumor1=as.numeric(gene_DE_matrix$tumor1)
gene_DE_matrix$tumor2=as.numeric(gene_DE_matrix$tumor2)
gene_DE_matrix$tumor3=as.numeric(gene_DE_matrix$tumor3)
gene_DE_matrix$tumor4=as.numeric(gene_DE_matrix$tumor4)
gene_DE_matrix$normal1=as.numeric(gene_DE_matrix$normal1)
gene_DE_matrix$normal2=as.numeric(gene_DE_matrix$normal2)
gene_DE_matrix$normal3=as.numeric(gene_DE_matrix$normal3)
gene_DE_matrix$normal4=as.numeric(gene_DE_matrix$normal4)
gene_DE_matrix=gene_DE_matrix[,-ncol(gene_DE_matrix)]
colnames(gene_DE_matrix)=colnames(data_NA)
colnames(gene_DE_matrix_adj)="padj"
my_group = data.frame(cond)
colnames(my_group)=c("Type")
my_group=data.frame(my_group)

write.table(gene_DE_matrix_adj, "list_gen_DE.tsv", sep="\t")

colors<-list('Type' = c('MT' = 'cyan', 'WT' = 'red'))

colAnn <- HeatmapAnnotation(df = my_group ,col = colors,which = 'col')

png("Clustering.png", w=480, h=480, pointsize=12)
Heatmap(as.matrix(gene_DE_matrix[1:6,]),column_title ="Sample Distance Matrix",
        cluster_rows = TRUE,cluster_columns = TRUE,
        cluster_row_slices = TRUE,cluster_column_slices =TRUE,
        col = colorRampPalette(brewer.pal(8, "RdYlBu"))(25),column_labels = colnames(gene_DE_matrix),
        row_km = 1,column_km = 1,top_annotation = colAnn)
dev.off()

ACP <- PCA(t(data_NA), scale.unit = TRUE, graph = FALSE)
png("ACP.png", w=480, h=480, pointsize=12)
plot(ACP, title = "ACP")
dev.off()


