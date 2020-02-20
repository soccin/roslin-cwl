#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: ExpressionTool
id: consolidate-files

requirements:
  - class: InlineJavascriptRequirement

inputs:

  runparams:
    type:
      type: record
      fields:
        genome: string
        assay: string
        pi: string
        pi_email: string
        project_prefix: string
  pair:
    type:
      type: array
      items:
        type: record
        fields:
          CN: string
          LB: string
          ID: string
          PL: string
          PU: string[]
          R1: File[]
          R2: File[]
          zR1: File[]
          zR2: File[]
          bam: File[]
          RG_ID: string[]
          adapter: string
          adapter2: string
          bwa_output: string
  bams:
    type: File[]
    secondaryFiles:
      - ^.bai

outputs:
  genome: string
  assay: string
  pi: string
  pi_email: string
  project_prefix: string
  normal_sample_name: string
  tumor_sample_name: string
  normal_bam:
    type: File
    secondaryFiles:
      - ^.bai
  tumor_bam:
    type: File
    secondaryFiles:
      - ^.bai

# This tool returns a Directory object,
# which holds all output files from the list
# of supplied input files
expression: |
  ${
    var output = {};
    output['genome'] = inputs.runparams.genome;
    output['assay'] = inputs.runparams.assay;
    output['pi'] = inputs.runparams.pi;
    output['pi_email'] = inputs.runparams.pi_email;
    output['project_prefix'] = inputs.runparams.project_prefix;
    output['normal_bam'] = inputs.bams[1];
    output['tumor_bam'] = inputs.bams[0];
    output['normal_sample_name'] = inputs.pair[1].ID;
    output['tumor_sample_name'] = inputs.pair[0].ID;
    return output;
  }
