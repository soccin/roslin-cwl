#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: copy-outputs

requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:

  vcf: File[]
  bam: File[]
  maf: File[]
  meta:
    type: File[]
    default: []
  facets:
    type:
      type: array
      items:
        type: record
        fields:
          normal_id: string
          tumor_id: string
          files: File[]

outputs:

  vcf_dir:
    type: Directory
    outputSource: collect_vcf/directory
  bam_dir:
    type: Directory
    outputSource: collect_bam/directory
  maf_dir:
    type: Directory
    outputSource: collect_maf/directory
  meta_files:
    type: File[]
    outputSource: meta
  facets:
    type: Directory
    outputSource: collect_facets/directory

steps:

  collect_vcf:
    run: ../tools/consolidate-files/consolidate-files.cwl
    in:
      files: vcf
      output_directory_name:
        valueFrom: ${ return "vcf"; }
    out: [directory]
  collect_bam:
    run: ../tools/consolidate-files/consolidate-files.cwl
    in:
      files: bam
      output_directory_name:
        valueFrom: ${ return "bam"; }
    out: [directory]
  collect_maf:
    run: ../tools/consolidate-files/consolidate-files.cwl
    in:
      files: maf
      output_directory_name:
        valueFrom: ${ return "maf"; }
    out: [directory]
  collect_facets:
    run: ../modules/project/consolidate_pairs.cwl
    in:
      pairs: facets
      output_directory_name:
        valueFrom: ${ return "facets"; }
      flatten_directories:
        valueFrom: ${ return false; }
    out: [directory]



