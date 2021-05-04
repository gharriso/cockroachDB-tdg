INPUT_DOCX=$1
OUTPUT_DOC=`echo $INPUT_DOCX|cut -f1 -d'.'` 
OUTPUT_DOC="${OUTPUT_DOC}.asciidoc"
echo $OUTPUT_DOC
pandoc --to asciidoc --from docx  "$INPUT_DOCX" >/tmp/$$.1
sed 's/{empty}//' <"/tmp/$$.1" >"/tmp/$$.2"
sed 's/]] +/]]/' <"/tmp/$$.2" >"/tmp/$$.3"
sed 's/] +/]/' <"/tmp/$$.3" >"/tmp/$$.4"
cp "/tmp/$$.4" "$OUTPUT_DOC"

# On the Mac, this will open the generated file in MS Word
 