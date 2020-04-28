#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: ExpressionTool
id: consolidate-files

requirements:
  - class: InlineJavascriptRequirement

inputs:

  output_directory_name: string

  files:
    type:
      type: array
      items:
        - File
        - string
        - 'null'
    default: []
  
  file_lists:
    type:
      type: array
      items:
        type: array
        items:
          - File
          - string
          - 'null'
    default: [[]]


outputs:

  directory:
    type: Directory

# This tool returns a Directory object,
# which holds all output files from the list
# of supplied input files
expression: |
  ${
    var output_files_list = [];
    function addFile(input_file_list) {
      var output_files = [];
      var input_files = input_file_list.filter(single_file => String(single_file).toUpperCase() != 'NONE');
      for (var i = 0; i < inputs.files.length; i++) {
        if(input_files[i]){
          output_files.push(input_file_list[i]);
        }
      }
      return output_files;          
    }
    output_files_list = addFile(inputs.files);
    for (var i = 0; i < inputs.file_lists.length; i++) {
      if(inputs.file_lists[i]){
        output_files_list.push(addFile(inputs.file_lists[i]));
      }
      
    }

    return {
      'directory': {
        'class': 'Directory',
        'basename': inputs.output_directory_name,
        'listing': output_files_list
      }
    };
  }
