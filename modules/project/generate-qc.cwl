#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: generate-qc
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}

inputs:

  db_files:
    type:
      type: record
      fields:
        fp_genotypes: File
        pairing_file: File
        request_file: File
        hotspot_list_maf: File
        conpair_markers: string
  runparams:
    type:
      type: record
      fields:
        project_prefix: string
        genome: string
        scripts_bin: string
  ref_fasta:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  bams:
    type:
      type: array
      items:
        type: array
        items: File
    secondaryFiles: [^.bai]
  clstats1:
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File
  clstats2:
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File
  md_metrics:
    type:
      type: array
      items:
        type: array
        items: File
  hs_metrics:
    type:
      type: array
      items:
        type: array
        items: File
  insert_metrics:
    type:
      type: array
      items:
        type: array
        items: File
  per_target_coverage:
    type:
      type: array
      items:
        type: array
        items: File
  qual_metrics:
    type:
      type: array
      items:
        type: array
        items: File
  doc_basecounts:
    type:
      type: array
      items:
        type: array
        items: File
  conpair_pileups:
    type:
      type: array
      items:
        type: array
        items: File
  directories:
    type:
      type: array
      items: Directory
  files:
    type:
      type: array
      items: File
  pairs:
    type:
      type: array
      items:
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
            group: string
            adapter: string
            adapter2: string
            bwa_output: string


outputs:

  consolidated_results:
    type: Directory
    outputSource: consolidate_results/directory
  qc_pdf:
    type: File
    outputSource: generate_qc/qc_pdf


steps:
  run-contamination:
    run: ../../tools/conpair/0.3.3/conpair-contaminations.cwl
    in:
      runparams: runparams
      db_files: db_files
      pileups: conpair_pileups
      npileup:
        valueFrom: ${ var output = []; for (var i=0; i<inputs.pileups.length; i++) { output=output.concat(inputs.pileups[i][1]); } return output; }
      tpileup:
        valueFrom: ${ var output = []; for (var i=0; i<inputs.pileups.length; i++) { output=output.concat(inputs.pileups[i][0]); } return output; }
      markers:
        valueFrom: ${ return inputs.db_files.conpair_markers; }
      pairing_file:
        valueFrom: ${ return inputs.db_files.pairing_file; }
      output_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix; }
    out: [ outfiles, pdf ]

  run-concordance:
    run: ../../tools/conpair/0.3.3/conpair-concordances.cwl
    in:
      normal_homozygous:
        valueFrom: ${ return true; }
      runparams: runparams
      db_files: db_files
      pileups: conpair_pileups
      npileup:
        valueFrom: ${ var output = []; for (var i=0; i<inputs.pileups.length; i++) { output=output.concat(inputs.pileups[i][1]); } return output; }
      tpileup:
        valueFrom: ${ var output = []; for (var i=0; i<inputs.pileups.length; i++) { output=output.concat(inputs.pileups[i][0]); } return output; }
      markers:
        valueFrom: ${ return inputs.db_files.conpair_markers; }
      pairing_file:
        valueFrom: ${ return inputs.db_files.pairing_file; }
      output_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix + "_homo"; }
    out: [ outfiles, pdf ]

  run-concordance-non-homozygous:
    run: ../../tools/conpair/0.3.3/conpair-concordances.cwl
    in:
      normal_homozygous:
        valueFrom: ${ return false; }
      runparams: runparams
      db_files: db_files
      pileups: conpair_pileups
      npileup:
        valueFrom: ${ var output = []; for (var i=0; i<inputs.pileups.length; i++) { output=output.concat(inputs.pileups[i][1]); } return output; }
      tpileup:
        valueFrom: ${ var output = []; for (var i=0; i<inputs.pileups.length; i++) { output=output.concat(inputs.pileups[i][0]); } return output; }
      markers:
        valueFrom: ${ return inputs.db_files.conpair_markers; }
      pairing_file:
        valueFrom: ${ return inputs.db_files.pairing_file; }
      output_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix + "_nohomo"; }
    out: [ outfiles, pdf ]

  put-conpair-files-into-directory:
    run: ../../tools/conpair/0.3.3/consolidate-conpair-files.cwl
    in:
      concordance_files: run-concordance/outfiles
      concordance_files_nohomo: run-concordance-non-homozygous/outfiles
      contamination_files: run-contamination/outfiles
      files:
        source: [ run-concordance/outfiles, run-concordance-non-homozygous/outfiles, run-contamination/outfiles ]
        linkMerge: merge_flattened
      output_directory_name:
        valueFrom: ${ return "conpair_output_files"; }
    out: [ directory ]

  qc_merge_and_hotspots:
    run: ../../tools/roslin-qc/qc-merge-and-hotspots.cwl
    in:
      aa_bams: bams
      pairs: pairs
      runparams: runparams
      ref_fasta: ref_fasta
      db_files: db_files
      clstats1: clstats1
      clstats2: clstats2
      bams:
        valueFrom: ${ var output = [];  for (var i=0; i<inputs.aa_bams.length; i++) { output=output.concat(inputs.aa_bams[i]); } return output; }
      grouping_list:
        valueFrom: ${ var output = [];  for (var i=0; i<inputs.pairs.length; i++) {  for (var j=0; j<inputs.pairs[i].length; i++) { var singleSample = inputs.pairs[i][j]["ID"] + ":" + inputs.pairs[i][j]["group"]; output=output.concat(singleSample); } } return output; }
      hs_metrics: hs_metrics
      md_metrics: md_metrics
      per_target_coverage: per_target_coverage
      insert_metrics: insert_metrics
      doc_basecounts: doc_basecounts
      qual_metrics: qual_metrics
      project_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix; }
      fp_genotypes:
        valueFrom: ${ return inputs.db_files.fp_genotypes }
      pairing_file:
        valueFrom: ${ return inputs.db_files.pairing_file }
      hotspot_list_maf:
        valueFrom: ${ return inputs.db_files.hotspot_list_maf }
      genome:
        valueFrom: ${ return inputs.runparams.genome; }
    out: [ qc_merged_directory ]
  generate_images:
    run: ../../tools/roslin-qc/generate-images.cwl
    in:
      runparams: runparams
      db_files: db_files
      data_dir:  qc_merge_and_hotspots/qc_merged_directory
      bin:
        valueFrom: ${ return inputs.runparams.scripts_bin; }
      file_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix; }
    out: [ output, images_directory, project_summary, sample_summary ]
  consolidate_results:
    run: ../../tools/consolidate-files/consolidate-files-mixed.cwl
    in:
      output_directory_name:
        valueFrom: ${ return "consolidated_metrics_data"; }
      input_directories: directories
      conpair_directory: put-conpair-files-into-directory/directory
      qc_merged_and_hotspots_directory: qc_merge_and_hotspots/qc_merged_directory
      generate_images_directory: generate_images/output
      files: files
      directories:
        valueFrom: ${ var metrics_data = [inputs.qc_merged_and_hotspots_directory, inputs.generate_images_directory, inputs.conpair_directory ]; return metrics_data.concat(inputs.input_directories); }
    out: [ directory ]
  generate_qc:
    run: ../../tools/roslin-qc/genlatex.cwl
    in:
      runparams: runparams
      db_files: db_files
      data_dir: consolidate_results/directory
      request_file:
        valueFrom: ${ return inputs.db_files.request_file; }
      project_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix; }
    out: [ qc_pdf ]