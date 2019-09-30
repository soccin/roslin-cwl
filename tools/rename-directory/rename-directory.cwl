#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: ExpressionTool
id: rename-directory

requirements:
  - class: InlineJavascriptRequirement

inputs:

  output_directory_name: string
  data_dir: Directory

outputs:

  directory:
    type: Directory

expression: |
  ${
    return {
      'directory': {
        'class': 'Directory',
        'basename': inputs.output_directory_name,
        'listing': inputs.data_dir.listing
      }
    };
  }
