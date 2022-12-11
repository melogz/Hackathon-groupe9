# Projet Hackathon du groupe 9

Projet repro-hackathon du groupe 9. Ce répertoire ressence les différents scripts, fichiers, schémas et données utilisés au cours de notre travail. 


## Hg38

Se trouve dans ce répertoire les deux scripts permettant le téléchargement du génome de référence Hg38, le script en python et le script bash pour l'éxécuter. 

## Docker

Les dockerfiles permettant de créer les images docker de chaque outil sont dans [docker](docker).

## Data

Les données utilisées sont les SRA dont les id sont dans [SraAccList.txt](SraAccList.txt) et les matrices d'expression des gênes sont [GSE39717](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE39717) and [GSE42740](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE42740).

## Workflow

Le workflow est implémenté avec Snakemake.

![Schema du workflow](assets/workflow.png?raw=true "Schema du workflow")

## TODO

Se référer à [TODO.md](TODO.md).
