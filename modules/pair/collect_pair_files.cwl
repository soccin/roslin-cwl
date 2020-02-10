#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: collect-pair-files

requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:

  pair:
    type:
      type: record
      fields:
        normal_id: string
        tumor_id: string
        files: File[]

outputs:

  directory:
    type: Directory
    outputSource: consolidate_per_pair/directory

steps:

  consolidate_per_pair:
    run: ../../tools/consolidate-files/consolidate-files.cwl
    in:
      pair: pair
      files:
        valueFrom: ${ return inputs.pair.files; }
      output_directory_name:
        valueFrom: ${ return inputs.pair.tumor_id + "." + inputs.pair.normal_id; }
    out: [directory]