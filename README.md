# Projet Hackathon du groupe 9

Projet repro-hackathon du groupe 9.

## Docker

Les dockerfile permettant de créer les images docker de chaque outil sont dans [docker](docker).

## Data

Les données utilisées sont les SRA dont les id sont dans [SraAccList.txt](SraAccList.txt) et les matrices d'expression des gênes sont [GSE39717](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE39717) and [GSE42740](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE42740).

## Workflow

Le workflow est implémenté avec Snakemake.

<div style="width:60px ; height:60px">
![Schema du workflow](assets/workflow.png?raw=true "Schema du workflow")
<div>

## TODO

Se référer à [TODO.md](TODO.md).