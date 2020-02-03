# roslin-cwl
CWLs for the Roslin pipeline.

## Folders

##### modules

##### tools

##### workflows

## CWLs

##### project-workflow.cwl

Given a set of paired tumor-normal samples, this CWL uses `workflows/pair-workflow.cwl` to do alignment, variant calling, and some metrics, followed by `modules/project/generate-qc.cwl` to compile QC data.

##### project-workflow-sv.cwl

Similar to `project-workflow.cwl`, given a set of paired tumor-normal samples, this CWL uses `workflows/pair-workflow-sv.cwl` to do alignment, variant calling (including structural variants), and some metrics, followed by `modules/project/generate-qc.cwl` to compile QC data for all tumor-normal pairs.
