<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:max="http://www.umcg.nl/MAX"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xsl max xsi xsd">

	<!--
		Maak MAX Export van de Content Package!

		[5-jul-2023]
		Principes nu NL tekst

		[15-mar-2023]
		applicatiefunctie NL tekst

		[1-mar-2022]
		io_out en io_in toegevoegd voor proces
		omgezet naar NL ipv EN

		[5-jan-2022]
		Omgezet naar alias en engels, nog te doen: Applicatiefuncties en Principes

		[25-apr-2018]
		Kolom type voor principes toegevoegd
		Kolom referenties toegevoegd voor appfunctie
		Kolom informatieobjecten toegevoegd voor appfunctie
		
		[24-nov-2017]
		Kolom domein_sortkey en bedrijfsfuncties toegevoegd aan appfuncties
		
		[20-nov-2017]
		Kolom volgorde aangepast, id kolommen achteraan, type kolom toegevoegd bij proces/functies tabs
		
		[6-nov-2017] ZiRA v0.3*
		Alle kolommen vullen, niet meer leeg maken als herhaling. Voor Functies en Processen.
		SortKey gebruik voor sorteren Domeinen.
		Tab applicatiefuncties toegevoegd.
		
		[6-jun-2017] ZiRA v0.2*
		_BA en _IO toegevoegd ivm verrijking Matprinrix met Domein 
	
		[3-jun-2017]
		ZIB kolom toegevoegd aan Informatieobjecten tabblad
	
		[3-mei-2017]
		Informatieobjecten tabblad toegevoegd
		Bedrijfsfuncties tabblad toegevoegd
	
		[5-apr-2017]
		Beschrijving en Bedrijfsfuncties toegevoegd.
		Bedrijfsactiviteiten sheet verwijderd.
	
		[10-okt-2016]
		Bijgesteld op 1ste RTU.
	
		[7-sep-2016]
		Dit script genereert een XML file met data voor de ZIRA spreadsheet sheets 
		op basis van een MAX export van de ZIRA eap.
		1. Processen
		2. Bedrijfsactiviteiten
	 -->

	<xsl:output indent="yes" method="xml" />
	<xsl:strip-space elements="*" />
	<xsl:variable name="nl"><xsl:text xml:space="preserve">
</xsl:text></xsl:variable>

	<xsl:template match="max:model">
		<zira>
			<principes>
				<!-- <line>
					<principe></principe>
					<beschrijving></beschrijving>
				</line> -->
				<xsl:for-each select="/max:model/objects/object[stereotype='ArchiMate_Principle']">
					<line>
						<type><xsl:if test="parentId=2516">BP</xsl:if><xsl:if test="parentId=2517">AP</xsl:if></type>
						<principe><xsl:value-of select="name"/></principe>
						<beschrijving><xsl:value-of select="substring-before(substring-after(notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
					</line>
				</xsl:for-each>
			</principes>
		
			<functies>
				<!-- <line>
					<bedrijfsfunctie>Bedrijfsfunctie</bedrijfsfunctie>
					<processtap>Processtap = Bedrijfsactiviteit</processtap>
					<beschrijving>Beschrijving</beschrijving>
					<zira_id>ZiRA id</zira_id>
				</line> -->
				<xsl:for-each select="/max:model/objects/object[stereotype='ArchiMate_BusinessFunction']">
					<xsl:variable name="bf_id" select="id"/>
					<xsl:variable name="bedrijfsfunctie" select="name"/>
					<line>
						<type>BF</type>
						<bedrijfsfunctie><xsl:value-of select="$bedrijfsfunctie"/></bedrijfsfunctie>
						<processtap></processtap>
						<beschrijving><xsl:value-of select="substring-before(substring-after(notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
						<zira_id><xsl:value-of select="$bf_id"/></zira_id>
					</line>
					
					<xsl:for-each select="/max:model/relationships/relationship[destId=$bf_id and stereotype='ArchiMate_Aggregation']">
						<xsl:variable name="sourceId" select="sourceId"/>
						<xsl:variable name="obj" select="/max:model/objects/object[id=$sourceId]"/>
						<xsl:if test="$obj/parentId=372">
							<line>
								<type>BA</type>
								<bedrijfsfunctie><xsl:value-of select="$bedrijfsfunctie"/></bedrijfsfunctie>
								<processtap><xsl:value-of select="$obj/name"/></processtap>
								<beschrijving><xsl:value-of select="substring-before(substring-after($obj/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
								<zira_id><xsl:value-of select="$obj/id"/></zira_id>
							</line>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</functies>
		
			<processen>
				<!-- <line>
					<type>type</type>
					<dienst>Dienst</dienst>
					<bedrijfsproces>Bedrijfsproces</bedrijfsproces>
					<werkproces>Werkproces</werkproces>
					<processtap>Processtap = Bedrijfsactiviteit</processtap>
					<beschrijving>Beschrijving</beschrijving>
					<io_in/>
					<io_out/>
					<bedrijfsfuncties>Bedrijfsfuncties</bedrijfsfuncties>
					<zira_id>ZiRA id</zira_id>
				</line> -->
				<xsl:for-each select="objects/object[stereotype='ArchiMate_BusinessService']">
					<xsl:variable name="dienstid" select="id"/>
					<!-- should be stereotype='ArchiMate_Realisation' instead of type='Realisation' -->
					<xsl:variable name="bpid" select="/max:model/relationships/relationship[destId=$dienstid and type='Realisation']/sourceId"/>
					<xsl:variable name="dienst" select="name"/>
					<xsl:variable name="bedrijfsproces" select="/max:model/objects/object[id=$bpid]/name"/>
					<line>
						<type>BP</type>
						<dienst><xsl:value-of select="$dienst"/></dienst>
						<bedrijfsproces><xsl:value-of select="$bedrijfsproces"/></bedrijfsproces>
						<werkproces/>
						<processtap/>
						<beschrijving><xsl:value-of select="substring-before(substring-after(/max:model/objects/object[id=$bpid]/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
						<io_in/>
						<io_out/>
						<bedrijfsfuncties/>
						<zira_id><xsl:value-of select="$bpid"/></zira_id>
					</line>
					<!-- should be stereotype='ArchiMate_Aggregation' instead of type='Aggregation' -->
					<xsl:for-each select="/max:model/relationships/relationship[destId=$bpid and type='Aggregation']">
						<xsl:variable name="wpid" select="sourceId"/>
						<xsl:variable name="werkproces" select="/max:model/objects/object[id=$wpid]/name"/>
						<line>
							<type>WP</type>
							<dienst><xsl:value-of select="$dienst"/></dienst>
							<bedrijfsproces><xsl:value-of select="$bedrijfsproces"/></bedrijfsproces>
							<werkproces><xsl:value-of select="$werkproces"/></werkproces>
							<processtap/>
							<beschrijving><xsl:value-of select="substring-before(substring-after(/max:model/objects/object[id=$wpid]/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
							<io_in/>
							<io_out/>
							<bedrijfsfuncties/>
							<zira_id><xsl:value-of select="$wpid"/></zira_id>
						</line>
						<!-- should be stereotype='ArchiMate_Aggregation' instead of type='Aggregation' -->
						<xsl:for-each select="/max:model/relationships/relationship[destId=$wpid and type='Aggregation']">
							<xsl:sort select="tag[@name='sortkey']/@value"/>

							<xsl:variable name="baid" select="sourceId"/>
							<xsl:variable name="ba" select="/max:model/objects/object[id=$baid]"/>
							<xsl:variable name="domeinid" select="/max:model/relationships/relationship[sourceId=$baid and stereotype='ArchiMate_Aggregation' and starts-with(destId,'2.16.840.1.113883.2.4.3.11.29.2.')]/destId"/>

							<xsl:variable name="baIORelIds_in" select="/max:model/relationships/relationship[destId=$baid and type='InformationFlow']/sourceId"/>
							<xsl:variable name="baIORelIds_out" select="/max:model/relationships/relationship[sourceId=$baid and type='InformationFlow']/destId"/>
							<xsl:variable name="baIOs_in" select="/max:model/objects/object[(id=$baIORelIds_in) and stereotype='ArchiMate_BusinessObject']/name"/>
							<xsl:variable name="baIOs_out" select="/max:model/objects/object[(id=$baIORelIds_out) and stereotype='ArchiMate_BusinessObject']/name"/>
							
							<line>
								<type>BA</type>
								<dienst><xsl:value-of select="$dienst"/></dienst>
								<bedrijfsproces><xsl:value-of select="$bedrijfsproces"/></bedrijfsproces>
								<werkproces><xsl:value-of select="$werkproces"/></werkproces>
								<processtap><xsl:value-of select="$ba/name"/></processtap>
								<beschrijving><xsl:value-of select="substring-before(substring-after($ba/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
								<io_in><xsl:value-of select="string-join($baIOs_in,$nl)"/></io_in>
								<io_out><xsl:value-of select="string-join($baIOs_out,$nl)"/></io_out>
								<bedrijfsfuncties><xsl:call-template name="bf-ba"><xsl:with-param name="baid" select="$baid"/></xsl:call-template></bedrijfsfuncties>
								<zira_id><xsl:value-of select="$baid"/></zira_id>
							</line>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
			</processen>
			
			<appfuncties>
				<!-- <line>
					<domein/>
					<applicatiefunctie/>
					<beschrijving/>
					<referenties/>External Reference e.g. EHR-S FM 
					<bedrijfsactiviteiten/>
					<informatieobjecten/>
					<bedrijfsfuncties/>
					<domein_sortkey/>
					<zira_id/>
				</line> -->
				<xsl:for-each select="/max:model/objects/object[stereotype='ArchiMate_ApplicationFunction' and parentId=2536]">
					<xsl:variable name="appfunctie" select="."/>
					<xsl:variable name="appfunctie_id" select="$appfunctie/id"/>
					<xsl:variable name="appDomeinIds" select="/max:model/relationships/relationship[sourceId=$appfunctie_id and stereotype='ArchiMate_Aggregation']/destId"/>
					<xsl:variable name="baIds" select="/max:model/relationships/relationship[sourceId=$appfunctie_id and stereotype='ArchiMate_Association']/destId"/>
					<xsl:variable name="bas" select="/max:model/objects/object[id=$baIds]/name"/>
					<xsl:variable name="baRelIds" select="/max:model/relationships/relationship[sourceId=$baIds and stereotype='ArchiMate_Aggregation']/destId"/>
					<xsl:variable name="domeinen" select="/max:model/objects/object[(id=$baRelIds and stereotype='ArchiMate_Grouping') or id=$appDomeinIds]/name"/>
					<xsl:variable name="domeinen_sortkey" select="/max:model/objects/object[(id=$baRelIds and stereotype='ArchiMate_Grouping') or id=$appDomeinIds]/tag[@name='SortKey']/@value"/>
					<xsl:variable name="bedrfunct" select="/max:model/objects/object[id=$baRelIds and stereotype='ArchiMate_BusinessFunction']/name"/>
					
					<xsl:variable name="baIORelIds" select="/max:model/relationships/relationship[sourceId=$baIds and type='InformationFlow']/destId"/>
					<xsl:variable name="baIORelIds2" select="/max:model/relationships/relationship[destId=$baIds and type='InformationFlow']/sourceId"/>
					<xsl:variable name="baIOs" select="/max:model/objects/object[(id=$baIORelIds or id=$baIORelIds2) and stereotype='ArchiMate_BusinessObject']/name"/>
					
					<line>
						<type>AF</type>
						<domeinen><xsl:value-of select="string-join($domeinen,$nl)"/></domeinen>
						<applicatiefunctie><xsl:value-of select="$appfunctie/name"/></applicatiefunctie>
						<beschrijving><xsl:value-of select="substring-before(substring-after($appfunctie/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
						<referenties><xsl:value-of select="$appfunctie/tag[@name='ExternalReference']/@value"/></referenties>
						<bedrijfsactiviteiten><xsl:value-of select="string-join($bas,$nl)"/></bedrijfsactiviteiten>
						<informatieobjecten><xsl:value-of select="string-join($baIOs,$nl)"/></informatieobjecten>
						<bedrijfsfuncties><xsl:value-of select="string-join($bedrfunct,$nl)"/></bedrijfsfuncties>
						<domeinen_sortkey><xsl:value-of select="string-join($domeinen_sortkey,$nl)"/></domeinen_sortkey>
						<zira_id><xsl:value-of select="$appfunctie_id"/></zira_id>
					</line>
				</xsl:for-each>
			</appfuncties>
			
			<IOs>
				<!-- <line>
					<informatiedomein>Informatiedomein</informatiedomein>
					<informatieobject>Informatieobject</informatieobject>
					<beschrijving>Beschrijving</beschrijving>
					<zibs>ZIB(s)</zibs>
					<informatiedomein_sortkey/>
					<zira_id>ZiRA id</zira_id>
					<rdz_id>RDZ ID</rdz_id>
				</line> -->
				<xsl:for-each select="/max:model/objects/object[stereotype='ArchiMate_BusinessObject' and parentId=376]">
					<xsl:variable name="sourceId" select="id"/>
					<xsl:variable name="destId" select="/max:model/relationships/relationship[sourceId=$sourceId and stereotype='ArchiMate_Aggregation']/destId"/>
					<xsl:variable name="informatiedomein" select="/max:model/objects/object[id=$destId and stereotype='ArchiMate_Grouping']"/>
					
					<xsl:variable name="zib_ids" select="/max:model/relationships/relationship[sourceId=$sourceId and stereotype='trace']/destId"/>
					<xsl:variable name="zibs" select="/max:model/objects/object[id=$zib_ids]/name"/>
				
					<line>
						<informatiedomein><xsl:value-of select="$informatiedomein/name"/></informatiedomein>
						<informatieobject><xsl:value-of select="name"/></informatieobject>
						<beschrijving><xsl:value-of select="substring-before(substring-after(notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></beschrijving>
						<zibs><xsl:value-of select="string-join($zibs,$nl)"/></zibs>
						<informatiedomein_sortkey><xsl:value-of select="$informatiedomein/tag[@name='SortKey']/@value"/></informatiedomein_sortkey>
						<zira_id><xsl:value-of select="id"/></zira_id>
						<rdz_id><xsl:value-of select="tag[@name='RDZ_ID']/@value"/></rdz_id>
					</line>
				</xsl:for-each>
			</IOs>
			
			<!-- Hidden helper werkbladen tbv de Matrix LOOKUP functie -->
			<_IOs>
				<xsl:for-each select="/max:model/objects/object[stereotype='ArchiMate_BusinessObject' and parentId=376]">
					<xsl:sort select="name"/>
					<xsl:variable name="sourceId" select="id"/>
					<xsl:variable name="destId" select="/max:model/relationships/relationship[sourceId=$sourceId and stereotype='ArchiMate_Aggregation']/destId"/>
					<xsl:variable name="informatiedomein" select="/max:model/objects/object[id=$destId and stereotype='ArchiMate_Grouping']"/>
					<line>
						<informatieobject><xsl:value-of select="name"/></informatieobject>
						<informatiedomein><xsl:value-of select="$informatiedomein/name"/></informatiedomein>
						<informatiedomein_sortkey><xsl:value-of select="$informatiedomein/tag[@name='SortKey']/@value"/></informatiedomein_sortkey>
						<zira_id><xsl:value-of select="id"/></zira_id>
					</line>
				</xsl:for-each>
			</_IOs>
			<_BAs>
				<xsl:for-each select="/max:model/objects/object[stereotype='ArchiMate_BusinessProcess' and parentId=372]">
					<xsl:sort select="name"/>
					<xsl:variable name="sourceId" select="id"/>
					<xsl:variable name="destId" select="/max:model/relationships/relationship[sourceId=$sourceId and stereotype='ArchiMate_Aggregation']/destId"/>
					<xsl:variable name="informatiedomein" select="/max:model/objects/object[id=$destId and stereotype='ArchiMate_Grouping']"/>
					<line>
						<bedrijfsactiviteit><xsl:value-of select="name"/></bedrijfsactiviteit>
						<informatiedomein><xsl:value-of select="$informatiedomein/name"/></informatiedomein>
						<informatiedomein_sortkey><xsl:value-of select="$informatiedomein/tag[@name='SortKey']/@value"/></informatiedomein_sortkey>
						<zira_id><xsl:value-of select="id"/></zira_id>
					</line>
				</xsl:for-each>
			</_BAs>
		</zira>
	</xsl:template>
	
	<xsl:template name="bf-ba">
		<xsl:param name="baid"/>
		<!-- ba agg rel naar wp -->
		<xsl:for-each select="/max:model/relationships/relationship[sourceId=$baid and type='Aggregation']">
			<!-- wp agg rel naar bf -->
			<xsl:variable name="wpid" select="destId"/>
			<xsl:for-each select="/max:model/relationships/relationship[sourceId=$wpid and type='Aggregation']">
				<xsl:variable name="bfid" select="destId"/>
				<xsl:variable name="bf" select="/max:model/objects/object[id=$bfid]"/>
				<xsl:if test="$bf/stereotype='ArchiMate_BusinessFunction'">
<xsl:value-of select="concat($bf/name,$nl)"/> 
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>