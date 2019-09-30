#/usr/bin/env cwl-runner
cwlVersion: v1.0

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-roslin-qc:0.6.1

class: CommandLineTool
baseCommand: [analyze_fingerprint]
id: generate-fingerprint
inputs:
  files:
    type:
      type: array
      items:
        type: array
        items: File
    inputBinding:
      prefix: -files
  file_prefix:
    type: string
    inputBinding:
      prefix: -pre
  fp_genotypes:
    type: File
    inputBinding:
      prefix: -fp
  grouping_file:
    type: File
    inputBinding:
      prefix: -group
  pairing_file:
    type: File
    inputBinding:
      prefix: -pair
  outdir:
    type: string
    default: "."
    inputBinding:
      prefix: -outdir
outputs:
  output:
    type:
      type: array
      items: File
    outputBinding:
      glob: |
        ${
            return inputs.file_prefix + "*";
        }

  fp_summary:
    type: File
    outputBinding:
      glob: |
        ${
            return inputs.file_prefix + "_FingerprintSummary.txt";
        }

  minor_contam_output:
    type: File
    outputBinding:
      glob: |
        ${
            return inputs.file_prefix + "_MinorContamination.txt";
        }
