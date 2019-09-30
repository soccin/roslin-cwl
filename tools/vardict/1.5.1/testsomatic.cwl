#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- /usr/bin/vardict/testsomatic.R
id: testsomatic
inputs:
- id: input_vardict
  type: File
outputs:
- id: output_var
  outputBinding:
    glob: output_testsomatic.var
  type: File?
requirements:
- class: DockerRequirement
  dockerPull: mskcc/roslin-variant-vardict:1.5.1
- class: InlineJavascriptRequirement
stdin: $(inputs.input_vardict.path)
stdout: output_testsomatic.var
