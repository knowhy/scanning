Linux scanning scripts
======================

About
-----

I use this repository to share scripts I use to scan my documents.

My scanner return faulty pnm files that is why I need to convert from pnm to png and again from png to pnm. So you probably don't need these extra steps.

Installation
------------

All scripts are written in Bash and don't need any installation.

Dependencies
------------

- Bash
- GNU parallel
- tesseract
- sane
- pdfunite
- pnm2png
- png2pnm
- unpaper

If you want to check out my attempt to compare different Linux OCR backends you will need

- cuneiform

as well.

Workflow
--------

Run

$ mass_scan.sh PREFIX

and the script will scan all documents in the ADF in your path as single files numbered with prefix.

Run

$ mass_ocr.sh

to run OCR engine against the single files, create pdf files with HOCR and merge the single files into one document for each prefix.
