# Projet Hackathon du groupe 9

Projet repro-hackathon du groupe 9. Ce répertoire recense les différents scripts, fichiers, schémas et données utilisés au cours de notre travail. 


## Hg38

Se trouve dans ce répertoire les deux scripts permettant le téléchargement du génome de référence Hg38, le script en python et le script bash pour l'éxécuter. (ces scripts sont des étapes intermediaires du snakefile général)

## analyse statistique

contient le scprit Deseq.R permettant de réaliser l'analyse statistique des résultats ( doit être lancer apres le run.sh qui lance le workflow)

## assets

Ce dossier contient les données utilisées les localisations des SRA [SraAccList.txt](SraAccList.txt) et Le workflow est implémenté avec Snakemake.
![Schema du workflow](assets/workflow.png?raw=true "Schema du workflow")

## Count copy

Ce dossier est le dossier d'output de notre snakemake général (workflow.smk) et recense la matrice de comptage et son résumé. 

## Docker

Les dockerfiles permettant de créer les images docker de chaque outil sont dans [docker](docker).

## Image_snakefile

Recense  les images de nos différents snakefiles (les différents snakefiles intermédaires et le workflow général)

## Snakemake

Contient les snakefiles de notre travail, les intermédiaires et le workflow général.


## que faire ?

en récupérant le git sur un repository local, lancez le script run.sh et dès que vous récuperez votre matrice de comptage vous pourrez utiliser le script DEseq.r
