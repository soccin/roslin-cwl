#!/bin/bash
mkdir -p ${1}/sv/work
mkdir -p ${1}/sv/out
mkdir -p ${1}/non_sv/work
mkdir -p ${1}/non_sv/out
cwltoil --singularity --logFile ${1}/sv/toil_log.log --batchSystem lsf --disable-user-provenance --disable-host-provenance --debug --disableCaching --preserve-environment PATH TMPDIR TOIL_LSF_ARGS SINGULARITY_PULLDIR SINGULARITY_CACHEDIR PWD --defaultMemory 8G --maxCores 16 --maxDisk 128G --maxMemory 256G --not-strict --realTimeLogging --jobStore ${1}/sv/jobstore --tmpdir-prefix /fscratch --workDir ${1}/sv/work --outdir ${1}/sv/out --maxLocalJobs 500 ../project-workflow-sv.cwl inputs.yaml &
SV_PROCESS=$!
cwltoil --singularity --logFile ${1}/non_sv/toil_log.log --batchSystem lsf --disable-user-provenance --disable-host-provenance --debug --disableCaching --preserve-environment PATH TMPDIR TOIL_LSF_ARGS SINGULARITY_PULLDIR SINGULARITY_CACHEDIR PWD --defaultMemory 8G --maxCores 16 --maxDisk 128G --maxMemory 256G --not-strict --realTimeLogging --jobStore ${1}/non_sv/jobstore --tmpdir-prefix /fscratch --workDir ${1}/non_sv/work --outdir ${1}/non_sv/out --maxLocalJobs 500 ../project-workflow.cwl inputs.yaml &
NON_SV_PROCESS=$!
wait $SV_PROCESS $NON_SV_PROCESS