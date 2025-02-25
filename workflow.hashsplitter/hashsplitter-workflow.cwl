#!/usr/bin/env cwlrunner

class: Workflow

cwlVersion: v1.0

inputs:
  - id: input
    type: File
    doc: "to be hashed all the ways"

outputs:
  - id: output
    type: File
    outputSource: unify/output

hints:
    - md5 -> http://tesk.com
    - sha -> http://tesk.com

steps:
  - id: md5
    run: hashsplitter-md5.cwl.yml
    in:
      - { id: input, source: input }
    out:
      - { id: output }

  - id: sha
    run: hashsplitter-sha.cwl.yml
    in:
      - { id: input, source: input }
    out:
      - { id: output }

  - id: whirlpool
    run: hashsplitter-whirlpool.cwl.yml
    in:
      - { id: input, source: input }
    out:
      - { id: output }

  - id: unify
    run: hashsplitter-unify.cwl.yml
    in:
      - { id: md5, source: md5/output }
      - { id: sha, source: sha/output }
      - { id: whirlpool, source: whirlpool/output }
    out:
      - { id: output }
