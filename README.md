![CI Status](https://github.com/vogdb/ngs-run-calculator-flutter/actions/workflows/ci.yml/badge.svg)
![gh-pages](https://github.com/vogdb/ngs-run-calculator-flutter/actions/workflows/gh-pages.yml/badge.svg)

## About
The Flutter implementation of the React app [ngs-run-calculator](https://github.com/vogdb/ngs-run-calculator). 

Calculator of the sequencing platform load. It helps to compute the proper number of samples for
sequencing based on some input information. You can try it [online](https://vogdb.github.io/ngs-run-calculator-flutter/)
or as [an Android app](https://play.google.com/store/apps/details?id=com.asanin.ngs.run.calculator).

### Dictionary
- **bp** - [base pair](https://en.wikipedia.org/wiki/Base_pair).

### Sequencing machine specification

- Name
    - Type of output kit. The list of High Output, Mid Output for NextSeq 500. The list of MiSeq Reagent Kit v2, MiSeq Reagent Kit v3, MiSeq Reagent Kit v2 Micro, MiSeq Reagent Kit v2 Nano for Miseq.
    - Library type. The list of paired-end, single-end. Multiply by 2 for paired and 1 for single.
    - Read length. Positive int. Dimensionality: `bp`.  

### Biosample type specification.
 Specification of possible biosamples. Every biosample is represented by a set of fields. For fields specification please see **Fields** below.
 
 - Amplicon-based metagenome
    - samples number
    - coverage [number of reads]
 - Pro-/eukaryotic genome
    - samples number
    - coverage [x]
    - genome size [bp]
 - Human exome
    - samples number
    - coverage [x]
    - target size [Mbp]  
 - Targeted panel
    - samples number
    - coverage [x]
    - target size [Mbp]  
 - Pro-/eukaryotic transcriptome
    - samples number
    - coverage [number of reads]    
 - Human genome (Don't implement now)
    - samples number
    - coverage [x]
    - genome size [Gbp]  
    
### Fields
 - **samples number**. Number of samples. Positive int. No dimensionality.    
 - **coverage**. Represented in 2 variants: *number of reads* and *x*.
    - *number of reads*. Expected number of reads per sample. Positive int. No dimensionality. At this variant we should use `mode_read` and `read_length` in calculations otherwise not.   
    - *x*. How much to multiply. For example 10 would mean that we ought to multiply by `10`. Positive int. No dimensionality. When presented in UI it should have `x` in the input's placeholder and right after the input field. So `x` is like a dimensionality.
 - **genome size**. Positive int. Dimensionality: `bp`, `Kbp`, `Mbp`, `Gbp`.   
 - **target size**. Positive int. Dimensionality: `bp`, `Kbp`, `Mbp`, `Gbp`.   

 
### Calculation

#### Example for amplicon-based metagenome
- sequencing platform
    - NextSeq
    - High Output Kit
    - library type = paired-end
    - read length = 150 bp
- number of samples = 10 
- coverage/number of reads = 50000 per sample

NextSeq + High Output Kit = 120 Gbp. 
Number of samples * Coverage * read length * 2 = result in bp.
For this example: 10 * 50,000 * 150 * 2 = 150,000,000 bp.

#### Example for human exome
- sequencing platform
    - NextSeq
    - High Output Kit
    - library type = paired-end
    - read length = 150
- number of samples = 2 
- coverage = 100 x
- target size = 60 Mbp

NextSeq + High Output Kit = 120 Gbp. 
Number of samples * target size (to bp) * coverage = result in bp.
For this example: 2 * 60,000,000 * 100 = 12,000,000,000 bp.

#### Sequencing machine load calculation
The max load of sequencing machine is set by a choice of parameters. Examples below show all possible loads for MiSeq and NextSeq sequencing platforms.

Example
 - NextSeq 500
 - High Output Kit
 - library type + read length = 1x75
 - sequencing output = 30 Gbp 

Example
 - NextSeq 500
 - High Output Kit
 - library type + read length = 2x75
 - sequencing output = 60 Gbp 

Example
 - NextSeq 500
 - High Output Kit
 - library type + read length = 2x150
 - sequencing output = 120 Gbp 

Example
 - NextSeq 500
 - Mid Output Kit
 - library type + read length = 2x75
 - sequencing output = 19 Gbp 

Example
 - NextSeq 500
 - Mid Output Kit
 - library type + read length = 2x150
 - sequencing output = 39 Gbp 

Example
 - MiSeq
 - MiSeq Reagent Kit v2
 - library type + read length = 2x25
 - sequencing output = 0.85 Gbp

Example
 - MiSeq
 - MiSeq Reagent Kit v2
 - library type + read length = 2x150
 - sequencing output = 5.1 Gbp
 
Example
 - MiSeq
 - MiSeq Reagent Kit v2
 - library type + read length = 2x250
 - sequencing output = 8.5 Gbp

Example
 - MiSeq
 - MiSeq Reagent Kit v3
 - library type + read length = 2x75
 - sequencing output = 3.8 Gbp

Example
 - MiSeq
 - MiSeq Reagent Kit v3
 - library type + read length = 2x300
 - sequencing output = 15 Gbp 

Example
 - MiSeq
 - MiSeq Reagent Kit v2 Micro
 - library type + read length = 2x150
 - sequencing output = 1.2 Gbp 

Example
 - MiSeq
 - MiSeq Reagent Kit v2 Nano
 - library type + read length = 2x150
 - sequencing output = 0.3 Gbp

Example
 - MiSeq
 - MiSeq Reagent Kit v2 Nano
 - library type + read length = 2x250
 - sequencing output = 0.5 Gbp
