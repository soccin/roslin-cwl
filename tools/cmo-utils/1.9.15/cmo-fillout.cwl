#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand: [cmo_fillout]
id: cmo-fillout

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 32000
    coresMin: 2
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-cmo-utils:1.9.15

doc: |
  Fillout allele counts for a MAF file using GetBaseCountsMultiSample on BAMs

inputs:
  maf:
    type: File
    doc: MAF file on which to fillout
    inputBinding:
      prefix: --maf

  pairing:
    type: ['null', File]
    doc: Tab separated pairing file, normal tumor
    inputBinding:
      prefix: --pairing-file

  bams:
    type:
      type: array
      items: [string, File]
    doc: BAM files to fillout with
    inputBinding:
      prefix: --bams

  ref_fasta:
    type: File
    doc: Reference assembly file of BAM files, e.g. hg19/grch37/b37
    inputBinding:
      prefix: --ref-fasta

  output:
    type: ['null', string]
    doc: Filename for output of raw fillout data in MAF/VCF format
    inputBinding:
      prefix: --output

  portal_output:
    type: ['null', string]
    doc: Filename for a portal-friendly output MAF
    inputBinding:
      prefix: --portal-output

  fillout:
    type: ['null', string]
    doc: Precomputed fillout file from GBCMS (using this skips GBCMS)
    inputBinding:
      prefix: --fillout

  n_threads:
    type:
    - 'null'
    - int
    default: 4
    doc: Multithreaded GBCMS
    inputBinding:
      prefix: --n_threads

  output_format:
    type: string
    doc: Output format MAF(1) or tab-delimited with VCF based coordinates(2)
    inputBinding:
      prefix: --format

outputs:

  fillout_out:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output)
            return inputs.output;
          else
            return inputs.maf.basename.replace(".maf", ".fillout");
        }

  portal_fillout:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.portal_output)
            return inputs.portal_output;
          else
            return inputs.maf.basename.replace(".maf", ".fillout.portal.maf");
        }
