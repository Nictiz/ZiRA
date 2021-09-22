
docs/ Generated HTML from the EA project
zira2xls/ Converts the MAX export of the ZiRA into a spreadsheet
ziraim2gv/ Converts the ZiRA Information model to GraphViz diagrams

----------------
ziraim2gv:
> java -jar /home/michael/Develop/saxon9he.jar -s:Informatiemodel\ ZORG\ Resultaten.max -xsl:ziraim-to-gv.xslt -o:Informatiemodel\ ZORG\ Resultaten.gv
> dot "Informatiemodel ZORG Resultaten.gv" -Tpng > Informatiemodel\ ZORG\ Resultaten.png

----------------
OpenGroup ENGLISH

English names lookup table from fods export of zira spreadsheet with english column.
> java -jar /home/michael/Develop/saxon9he.jar -s:/tmp/zira.fods -xsl:english.xslt -o:english.xml 

> java -jar /home/michael/Develop/saxon9he.jar -s:Informatiemodel\ ZORG\ Resultaten.max -xsl:ziraim-to-gv-en.xslt -o:Informatiemodel\ ZORG\ Resultaten-en.gv
> dot "Informatiemodel ZORG Resultaten-en.gv" -Tpng > Informatiemodel\ ZORG\ Resultaten-en.png

> java -jar /home/michael/Develop/saxon9he.jar -s:Informatiemodel\ ZORG\ Activiteiten.max -xsl:ziraim-to-gv-en.xslt -o:Informatiemodel\ ZORG\ Activiteiten-en.gv
> dot "Informatiemodel ZORG Activiteiten-en.gv" -Tpng > Informatiemodel\ ZORG\ Activiteiten-en.png
