#!/usr/bin/env bash
#
# script to compare scan resolutions, modes with OCR results of tesseract and cuneiform
#

# scan modes supported by your scanner
modes=( Lineart Gray Color )
# resolutions supported by your scanner
resolutions=(75 100 200 300 600)

cd /path/to/scan-test/folder

cat words.txt | uniq | sort > uniq-words.txt 

#echo "#scan_mode scan_resolution file_size scan_time cuneiform_time tesseract_time cuneiform_word_count_total cuneiform_word_count_uniq cuneiform_word_correct cuneiform_word_not_found cuneiform_word_false_positive tesseract_word_count_total tesseract_word_count_uniq tesseract_word_correct tesseract_word_not_found tesseract_word_false_positive" > results.dat

echo "#scan_mode scan_resolution file_size scan_time tesseract_time tesseract_word_count_total tesseract_word_count_uniq tesseract_word_correct tesseract_word_not_found tesseract_word_false_positive" >> results.dat

for mode in "${modes[@]}"; do
      for resolution in "${resolutions[@]}"; do

	  # JPEG compression
	  ( export TIMEFORMAT='%E';time scanimage --mode $mode --resolution $resolution --compression JPEG > example-letter-$mode-$resolution.jpeg ) 2>  scan_time
	  file_size=`ls -s example-letter-$mode-$resolution.jpeg | cut -d " " -f1`

	  # cuneifrom OCR
	  export TIMEFORMAT='%E';time cuneiform -o example-letter-$mode-$resolution-cuneiform.txt -l eng example-letter-$mode-$resolution.jpeg > cuneiform_time_tmp
	  cuneiform_time=`cat cuneiform_time_tmp | tail -2`
	  cuneiform_word_count_total=`cat example-letter-$mode-$resolution-cuneiform.txt | tr " " "\n" | | tr -d '[[:space:]]' | wc -l`
	  cuneiform_word_count_uniq=`cat example-letter-$mode-$resolution-cuneiform.txt | tr " " "\n" | tr -d '[[:space:]]' | uniq | wc -l`
	  cat example-letter-$mode-$resolution-cuneiform.txt | tr " " "\n" | tr -d '[[:space:]]' | uniq | sort > example-letter-$mode-$resolution-cuneiform-uniq-words.txt
	  cuneiform_word_correct=`comm -12 example-letter-$mode-$resolution-cuneiform-uniq-words.txt uniq-words.txt | wc -l`
	  cuneiform_word_not_found=`comm -13 example-letter-$mode-$resolution-cuneiform-uniq-words.txt uniq-words.txt | wc -l`
	  cuneiform_word_false_positive=`comm -23 example-letter-$mode-$resolution-cuneiform-uniq-words.txt uniq-words.txt | wc -l`

	  #tesseract OCR
	  export TIMEFORMAT='%E';time tesseract -l eng --tessdata-dir /usr/share/ example-letter-$mode-$resolution.jpeg example-letter-$mode-$resolution-tesseract > tesseract_time
	  tesseract_word_count_total=`cat example-letter-$mode-$resolution-tesseract.txt | tr " " "\n" | wc -l`
	  tesseract_word_count_uniq=`cat example-letter-$mode-$resolution-tesseract.txt | tr " " "\n" | uniq | wc -l`
	  cat example-letter-$mode-$resolution-tesseract.txt | tr " " "\n" | uniq | sort > example-letter-$mode-$resolution-tesseract-uniq-words.txt
	  tesseract_word_correct=`comm -12 example-letter-$mode-$resolution-tesseract-uniq-words.txt uniq-words.txt | wc -l`
	  tesseract_word_not_found=`comm -13 example-letter-$mode-$resolution-tesseract-uniq-words.txt uniq-words.txt | wc -l`
	  tesseract_word_false_positive=`comm -23 example-letter-$mode-$resolution-tesseract-uniq-words.txt uniq-words.txt | wc -l`

	  echo "$mode $resolution $file_size $scan_time $cuneiform_time $cuneiform_word_count_total $cuneiform_word_count_uniq $cuneiform_word_correct $cuneiform_word_not_found $cuneiform_word_false_positive" >> results.dat
	  echo "\n" >> results.dat
	  
	  echo "$mode $resolution $file_size $scan_time $tesseract_time $tesseract_word_count_total $tesseract_word_count_uniq $tesseract_word_correct $tesseract_word_not_found $tesseract_word_false_positive" >> results.dat
	  echo "$mode $resolution $file_size $scan_time $tesseract_time $tesseract_word_count_total $tesseract_word_count_uniq $tesseract_word_correct $tesseract_word_not_found $tesseract_word_false_positive" >> results.dat 

	  
      done
done

# clean
rm -f example-letter*
