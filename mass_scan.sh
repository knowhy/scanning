#!/usr/bin/env bash
#
# mass scan script
#
# script to mass scan with a home scanner with ADF.
#
# The script takes one parameter with is used as a prefix. If there already files with the given prefix in the scans folder the script will increment the batch_number.

mode=Lineart
resolution=300

scan_path=/path/to/your/scan/folder

date=`date +%Y-%m-%d-%s`
batch_start=`ls $scan_path/$1* | cut -d - -f2 | cut -d . -f1 | sort -g | tail -n 1`

scanimage -x 210 -y 297 --source ADF --batch --mode $mode --resolution $resolution --batch=$scan_path/$1-%d.pnm --batch-start=$((batch_start+1))

