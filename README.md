
### Folders

* docs/ Generated HTML from the Enterprise Architect project

* artifacts/ Different generated versions of the ZiRA model (master source is the ZiRA Enterprise Architect Project): XLSX, MAX, XML, ArchMate

* xslts/zira2xls/ Converts the MAX export of the ZiRA into a spreadsheet

* xslts/ziraim2gv/ Converts the ZiRA Information model to GraphViz diagrams

### XSLT "Scripts"

XSLT met Saxon HE 11.5 https://github.com/Saxonica/Saxon-HE/releases
Extract saxon-he-11.5.jar and lib folder

#### Generate spreadsheets: xslt/zira2xls

Export de elementen package als .max uit de NL of EN versie.
Of gebruik artifacts/zira-1.4-element-(nl of en).max.

```
java -jar xslt/saxon-he-11.5.jar -s:artifacts/zira-1.4-elements-nl.max -xsl:xslt/zira2xls/zira2sheet.xslt -o:artifacts/zira-1.4-nl.xml
java -jar xslt/saxon-he-11.5.jar -s:artifacts/zira-1.4-elements-en.max -xsl:xslt/zira2xls/zira2sheet.xslt -o:artifacts/zira-1.4-en.xml
```

Then import the xml file using LibreOffice "XML Source" and map each type/line to the top/left column of a sheet.
Export matrixes as CSV, import and paste in, then sort in lookup sortkeys!

#### Generate Graphviz xslt/ziraim2gv

Export de Informatie model views ("Informatiemodel Zorg Resultaten" en "Informatiemodel Zorg Activiteiten") als .max uit de NL of EN versie.

```
java -jar xslt/saxon-he-11.5.jar -s:artifacts/Informatiemodel\ ZORG\ Resultaten.max -xsl:xslt/ziraim2gv/ziraim-to-gv.xslt -o:artifacts/Informatiemodel\ ZORG\ Resultaten.gv
java -jar xslt/saxon-he-11.5.jar -s:artifacts/Informatiemodel\ ZORG\ Activiteiten.max -xsl:xslt/ziraim2gv/ziraim-to-gv.xslt -o:artifacts/Informatiemodel\ ZORG\ Activiteiten.gv
java -jar xslt/saxon-he-11.5.jar -s:artifacts/Information\ Model\ CARE\ Results.max -xsl:xslt/ziraim2gv/ziraim-to-gv.xslt -o:artifacts/Information\ Model\ CARE\ Results.gv
java -jar xslt/saxon-he-11.5.jar -s:artifacts/Information\ model\ CARE\ Activities.max -xsl:xslt/ziraim2gv/ziraim-to-gv.xslt -o:artifacts/Information\ model\ CARE\ Activities.gv
```

```
dot artifacts/Informatiemodel\ ZORG\ Resultaten.gv -Tpng > artifacts/Informatiemodel\ ZORG\ Resultaten.png
dot artifacts/Informatiemodel\ ZORG\ Activiteiten.gv -Tpng > artifacts/Informatiemodel\ ZORG\ Activiteiten.png
dot artifacts/Information\ Model\ CARE\ Results.gv -Tpng > artifacts/Information\ Model\ CARE\ Results.png
dot artifacts/Information\ model\ CARE\ Activities.gv -Tpng > artifacts/Information\ model\ CARE\ Activities.png
```
