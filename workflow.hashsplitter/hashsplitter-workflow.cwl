#!/usr/bin/env cwlrunner

class: Workflow

cwlVersion: v1.2

requirements:
  StepInputExpressionRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  SchemaDefRequirement:
    types:
      - name: hash-methods
        symbols: ["all", "sha", "md5", "whirlpool"]
        type: enum

inputs:
  - id: datasets
    type: File[]
    doc: "to be hashed all the ways"
  - id: methods
    type:
      type: array
      items: hash-methods
    default: ["all"]

outputs:
  - id: output
    type: File
    outputSource: unify/output


steps:
  - id: md5
    run: hashsplitter-md5.cwl.yml
    when: $(inputs.methods.includes("all") || inputs.methods.includes("md5"))
    in:
      input:
        source: datasets
        valueFrom: $(inputs.input[0])
      methods: methods
    out:
      - { id: output }

  - id: sha
    run: hashsplitter-sha.cwl.yml
    when: $(inputs.methods.includes("all") || inputs.methods.includes("sha"))
    in:
      input:
        source: datasets
        valueFrom: $(inputs.input[0])
      methods: methods
    out:
      - { id: output }

  - id: whirlpool
    run: hashsplitter-whirlpool.cwl.yml
    when: $(inputs.methods.includes("all") || inputs.methods.includes("whirlpool"))
    in:
      input:
        source: datasets
        valueFrom: $(inputs.input[0])
      methods: methods
    out:
      - { id: output }

  - id: unify
    run: hashsplitter-unify.cwl.yml
    in:
      hashes:
        source: [md5/output, sha/output, whirlpool/output]
        pickValue: all_non_null
    out:
      - { id: output }
