INPUT_DOCX=$1
OUTPUT_DOC=`echo $INPUT_DOCX|cut -f1 -d'.'` 
OUTPUT_DOC="${OUTPUT_DOC}.asciidoc"
echo $OUTPUT_DOC
pandoc --to asciidoc --from docx  $INPUT_DOCX >$OUTPUT_DOC

# On the Mac, this will open the generated file in MS Word
 