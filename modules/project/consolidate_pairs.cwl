#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: consolidate-pairs

requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:

  output_directory_name: string

  flatten_directories: boolean

  pairs:
    type:
      type: array
      items:
        type: record
        fields:
          normal_id: string
          tumor_id: string
          files: File[]

outputs:

  directory:
    type: Directory
    outputSource: consolidate_pairs/directory

steps:

  consolidate_per_sample:
    run: ../pair/collect_pair_files.cwl
    in:
      pair: pairs
    scatter: [ pair ]
    scatterMethod: dotproduct
    out: [directory]

  consolidate_pairs:
    run: ../../tools/consolidate-files/consolidate-files-mixed.cwl
    in:
      output_directory_name: output_directory_name
      directories: consolidate_per_sample/directory
      flatten_directories: flatten_directories

    out: [directory]
