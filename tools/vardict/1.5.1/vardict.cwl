#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: vardict
inputs:
- id: bedfile
  type: File?
- id: b2
  type: File?
- id: b
  type: File?
- default: true
  id: C
  type: boolean?
- id: D
  type: boolean?
- id: N
  type: string?
- id: N2
  type: string?
- id: x
  type: string?
- id: z
  type: string?
- id: th
  type: string?
- id: M
  type: string?
- id: I
  type: string?
- id: H
  type: boolean?
- id: F
  type: string?
- id: E
  type: string?
- id: T
  type: string?
- id: m
  type: string?
- id: k
  type: string?
- id: i
  type: boolean?
- id: hh
  type: boolean?
- id: g
  type: string?
- id: f
  type: string?
- id: e
  type: string?
- id: d
  type: string?
- id: c
  type: string?
- id: a
  type: string?
- id: O
  type: string?
- id: P
  type: string?
- id: Q
  type: string?
- id: R
  type: string?
- id: V
  type: string?
- id: VS
  type: string?
- id: X
  type: string?
- id: Z
  type: string?
- id: B
  type: int?
- id: S
  type: string?
- id: n
  type: string?
- id: o
  type: string?
- id: p
  type: boolean?
- id: q
  type: string?
- id: r
  type: string?
- id: vcf
  type: string?
- id: G
  type: File
- id: f_1
  type: string?
label: vardict
outputs:
- id: output
  outputSource:
  - vardict_1/output
  type: File
requirements:
- class: InlineJavascriptRequirement
steps:
- id: vardict
  in:
  - id: B
    source: B
  - default: true
    id: C
    source: C
  - default: false
    id: D
    source: D
  - id: E
    source: E
  - id: F
    source: F
  - id: G
    source: G
  - id: H
    source: H
  - id: I
    source: I
  - id: M
    source: M
  - id: N
    source: N
  - id: O
    source: O
  - id: P
    source: P
  - id: Q
    source: Q
  - id: R
    source: R
  - id: S
    source: S
  - id: T
    source: T
  - id: V
    source: V
  - id: VS
    source: VS
  - id: X
    source: X
  - id: Z
    source: Z
  - id: a
    source: a
  - id: b
    source: b
  - id: b2
    source: b2
  - id: bedfile
    source: bedfile
  - id: c
    source: c
  - id: d
    source: d
  - id: e
    source: e
  - id: f
    source: f
  - id: g
    source: g
  - id: hh
    source: hh
  - id: i
    source: i
  - id: k
    source: k
  - id: m
    source: m
  - id: n
    source: n
  - id: o
    source: o
  - id: p
    source: p
  - id: q
    source: q
  - id: r
    source: r
  - id: th
    source: th
  - id: x
    source: x
  - id: z
    source: z
  out:
  - id: output
  run: ./vardict_app.cwl
- id: vardict_1
  in:
  - id: N
    source: N
  - id: N2
    source: N2
  - id: f
    source: f_1
  - id: vcf
    source: vcf
  - id: input_vcf
    source: testsomatic/output_var
  out:
  - id: output
  run: ./var_to_vcf.cwl
- id: testsomatic
  in:
  - id: input_vardict
    source: vardict/output
  label: testsomatic
  out:
  - id: output_var
  run: ./testsomatic.cwl
