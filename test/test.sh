#!/bin/bash
run_test() {
	mkdir -p ${1}/${2}/work
	mkdir -p ${1}/${2}/out
	cwltoil --singularity --logFile ${1}/sv/toil_log.log --batchSystem lsf --disable-user-provenance --disable-host-provenance --debug --clean never --disableCaching --preserve-environment PATH TMPDIR TOIL_LSF_ARGS SINGULARITY_PULLDIR SINGULARITY_CACHEDIR PWD --defaultMemory 8G --maxCores 16 --maxDisk 128G --maxMemory 256G --not-strict --realTimeLogging --jobStore ${1}/${2}/jobstore --tmpdir-prefix /scratch --workDir ${1}/${2}/work --outdir ${1}/${2}/out --maxLocalJobs 500 ${3} ${4} &
	return $!
}

# Test the SV cwl

run_test $1 sv ../project-workflow-sv inputs.yaml
SV_PROCESS=$?

# Test the non SV cwl

run_test $1 non_sv ../project-workflow.cwl inputs.yaml
NON_SV_PROCESS=$?

# Test the copy outputs cwl

run_test $1 copy_outputs ../workflows/copy_outputs.cwl copy_outputs.yaml
COPY_OUTPUTS_PROCESS=$?

# Test the copy outputs cwl without meta

run_test $1 copy_outputs_without_meta ../workflows/copy_outputs.cwl copy_outputs_without_meta.yaml
COPY_OUTPUTS_WITHOUT_META_PROCESS=$?

wait $SV_PROCESS $NON_SV_PROCESS $COPY_OUTPUTS_PROCESS $COPY_OUTPUTS_WITHOUT_META_PROCESS