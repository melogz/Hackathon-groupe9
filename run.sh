source docker/buildAndRunFastqdump.sh
source docker/BuildAndRunSTAR.sh
source docker/BuildAndRunSubread.sh
snakemake -s Workflow.smk --core 16