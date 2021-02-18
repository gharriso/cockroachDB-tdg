INPUT_ADOC=$1
asciidoctor --backend docbook --out-file - $INPUT_ADOC| \
pandoc --from docbook --to docx --output $INPUT_ADOC.docx

# On the Mac, this will open the generated file in MS Word
open $INPUT_ADOC.docx