<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	xmlns:sqfs	= "http://www.schematron-quickfix.com/sample"
	queryBinding="xslt2">
	
	
	<xsl:include href="outsource-docbook-chapters-gui.xsl"/>
	
	
	<sch:ns uri="http://docbook.org/ns/docbook" 				prefix="db"/>
	<sch:ns uri="http://www.schematron-quickfix.com/utility" 	prefix="sqfu"/>
	<sch:ns uri="http://www.schematron-quickfix.com/sample" 	prefix="sqfs"/>
	
	
	<sch:pattern>
		<sch:rule context="db:book/db:chapter">
			
			<sch:report test="string(@xml:base) = ''" role="warn" sqf:fix="outsourceChapters1 outsourceChapters2">
				Chapter <sch:value-of select="count(preceding-sibling::db:chapter) + 1"/> '<sch:value-of select="db:title"/>' should be placed in its own file and referenced with XInclude.
			</sch:report>
			
			
			<sqf:fix id="outsourceChapters1">
				
				<sqf:description>
					<sqf:title>Outsource all remaining chapters in individual files. (real)</sqf:title>
					<sqf:p>Generates a new file for each chapter and repaces the content by an XInclude element.</sqf:p>
					<sqf:p>This version is not working in oXygen, since it currently can't handle XIncludes within SQF correctly.</sqf:p>
				</sqf:description>
				
				<sch:let name="filenames" value="sqfs:getFilenames(parent::db:book)"/>
				
				<sqf:replace match="parent::db:book/db:chapter[string(@xml:base) = '']">
					<xsl:call-template name="oursourceChapter">
						<xsl:with-param name="filenames"	select="$filenames"/>
					</xsl:call-template>
				</sqf:replace>
				
			</sqf:fix>
			

			<sqf:fix id="outsourceChapters2">
				
				<sqf:description>
					<sqf:title>Outsource all remaining chapters in individual files. (fake)</sqf:title>
					<sqf:p>Generates a new file for each chapter and repaces the content by an XInclude element.</sqf:p>
					<sqf:p>This version does not generate xi:include elements but xi:Include instead to demonstrate it in oXygen as well.</sqf:p>
				</sqf:description>
				
				<sch:let name="filenames" value="sqfs:getFilenames(parent::db:book)"/>
				
				<sqf:replace match="parent::db:book/db:chapter[string(@xml:base) = '']">
					<xsl:call-template name="oursourceChapter">
						<xsl:with-param name="filenames"	select="$filenames"/>
						<xsl:with-param name="fake" 		select="true()"/>
					</xsl:call-template>
				</sqf:replace>
				
			</sqf:fix>

		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>