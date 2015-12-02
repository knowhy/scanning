#!/usr/bin/env bash
#
# mass ocr scanned files with tesseract
#
#
# This script runs tesseract OCR on every pnm file in $scan_path and creates a pdf files with hOCR overlay. The script uses GNU parallel to optimze the process for many files.
# The script expects an bunch of single page pnm files with common prefix. Files with prefix will be merged to one pdf file after the OCR process has finished.
#
# dependencies:
# - tesseract
# - GNU parallel
# - pnm2png
# - png2pnm
# - unpaper
# - pdfunite
#
# as my scanner creates faulty pnm files. So I convert the files to png and again to pnm (you might not need these steps and it is likely not the best way to deal with this problem.)
# $lang can be set to anything supported by your tesseract installation (run tesseract --list-langs to list your supported languages)

lang=deu
scan_path=/path/to/your/scanned/files

cd $scan_path

function pnm2ocrpdf {
    file=$1
    basename=`echo $file | cut -d . -f1`
    pnm2png $file $basename.png
    png2pnm $basename.png $basename.pnm
    unpaper $basename.pnm $basename-unpaper.pnm
    tesseract -l deu --tessdata-dir /usr/share $basename-unpaper.pnm $basename pdf
    # cleanup
    rm $basename.pnm
    rm $basename.png
    rm $basename-unpaper.pnm
}

export -f pnm2ocrpdf
parallel pnm2ocrpdf ::: $scan_path/*.pnm

# merge pdf files by prefix
for doc in $( ls -v $scan_path/*.pdf | cut -d - -f1 | uniq ); do
    pdfunite $doc-*.pdf $doc.pdf
    # cleanup
    rm $doc-*.pdf
done
