
docs/ Generated HTML from the Enterprise Architect project

artifacts/ Different generated versions of the ZiRA model (master source is the ZiRA Enterprise Architect Project): XLSX, MAX, XML, ArchMate

xslts/zira2xls/ Converts the MAX export of the ZiRA into a spreadsheet

xslts/ziraim2gv/ Converts the ZiRA Information model to GraphViz diagrams

xslts/appfuncties2max/ Temporary conversion script from RDZ

scripts/adden2max.js Convert the English translations spreadsheet to a max file for import in the EA model 

scripts/zira2xml.js

===============
xslt/ziraim2gv:

> java -jar /home/michael/Develop/saxon9he.jar -s:Informatiemodel\ ZORG\ Resultaten.max -xsl:ziraim-to-gv.xslt -o:Informatiemodel\ ZORG\ Resultaten.gv
> dot "Informatiemodel ZORG Resultaten.gv" -Tpng > Informatiemodel\ ZORG\ Resultaten.png

----------------
xslt/ziraim2gv: OpenGroup ENGLISH

N.B. zira.fods is "ZiRA v1.0 Spreadsheet+Matrix July 11 2021+EN.xlsx" converted to Open Office Sheets.

English names lookup table from fods export of zira spreadsheet with english column.
> java -jar /home/michael/Develop/saxon9he.jar -s:/tmp/zira.fods -xsl:english.xslt -o:english.xml 

> java -jar /home/michael/Develop/saxon9he.jar -s:Informatiemodel\ ZORG\ Resultaten.max -xsl:ziraim-to-gv-en.xslt -o:Informatiemodel\ ZORG\ Resultaten-en.gv
> dot "Informatiemodel ZORG Resultaten-en.gv" -Tpng > Informatiemodel\ ZORG\ Resultaten-en.png

> java -jar /home/michael/Develop/saxon9he.jar -s:Informatiemodel\ ZORG\ Activiteiten.max -xsl:ziraim-to-gv-en.xslt -o:Informatiemodel\ ZORG\ Activiteiten-en.gv
> dot "Informatiemodel ZORG Activiteiten-en.gv" -Tpng > Informatiemodel\ ZORG\ Activiteiten-en.png
-----------------
xslt/zira2xls:

N.B. artifacts/zira-1.2-elements-nl+en.max is the latest version with SortKey!

> java -jar /home/michael/Develop/saxon9he.jar -s:artifacts/zira-1.2-elements-nl+en.max -xsl:xslt/zira2xls/zira2sheet-5-nl.xslt -o:artifacts/zira-1.2-nl.xml
> java -jar /home/michael/Develop/saxon9he.jar -s:artifacts/zira-1.2-elements-nl+en.max -xsl:xslt/zira2xls/zira2sheet-5-en.xslt -o:artifacts/zira-1.2-en.xml
.. then import the xml file using LibreOffice "XML Source" and map each type/line to the top/left column of a sheet  

-----------------
scripts (OBSOLETE):
adden2max.js: Adding engligh translation to original zira-v1.0.max file

> docker run -it -v "$(pwd)":/app node:lts-buster /bin/bash
@> cd /app/scripts
@> node adden2max.js > output.max
.. then import the file in dit ZiRA v1.0.eap using EA and the MAX extension
.. then export the whole model to v-1.0-en-full.max

zira2xsl.js: Convert max to xml for import in spreadsheet
@> cd /app/scripts
@> node zira2xml.js > ../artifacts/tmp-zira-1.0-en.xml
.. then import the xml into a spreadsheet using LibreOffice XML Data Source
