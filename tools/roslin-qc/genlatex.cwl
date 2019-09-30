#!/usr/bin/env cwl-runner
cwlVersion: v1.0

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: $(inputs.data_dir.listing)
  ResourceRequirement:
    ramMin: 8000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-roslin-qc:0.6.1

class: CommandLineTool
baseCommand:
  - python
  - /usr/bin/genlatex.py

id: genlatex

inputs:

  data_dir:
    type: Directory

  input_dir:
    type: [ 'null', string ]
    default: "."
    inputBinding:
      prefix: --path

  request_file:
    type: File
    inputBinding:
      prefix: --request_file

  project_prefix:
    type: [ 'null', string ]
    inputBinding:
      prefix: --full_project_name

outputs:
  qc_pdf:
    type: File
    outputBinding:
      glob: "*_QC_Report.pdf"

