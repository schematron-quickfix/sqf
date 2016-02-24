<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	queryBinding="xslt2">
	
	<xsl:include href="handle-docbook-xincludes.xsl"/>
	
	<xsl:include href="../SqfUtil/sqfu-copy-of.xsl"/>
	
	
	<sch:ns uri="http://docbook.org/ns/docbook" 				prefix="db"/>
	<sch:ns uri="http://www.schematron-quickfix.com/utility" 	prefix="sqfu"/>
	
	
	<sch:pattern>
		<sch:rule context="db:chapter">
			
			<sch:report test="contains(lower-case(db:title), 'appendix')" role="warn" sqf:fix="chapterToAppendix1 chapterToAppendix2 chapterToAppendix3">
				A chapter with 'appendix' in its title us an appendix instead. 
			</sch:report>
			
			<sqf:fix id="chapterToAppendix1">
				<sqf:description>
					<sqf:title>Convert chapter to appendix element. (minimal)</sqf:title>
					<sqf:p>Version with minimal code. It has the drawback that the xincludes are resolved and the spaces within programlisting are not preserved.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="appendix" select="attribute() | node()"/>
			</sqf:fix>
			
			<sqf:fix id="chapterToAppendix2">
				<sqf:description>
					<sqf:title>Convert chapter to appendix element. (XSLT)</sqf:title>
					<sqf:p>An XSLT solution that recursively processes the content and recreates the xInclude, but without any xi:fallback.</sqf:p>
					<sqf:p>For an unknown reason, when being applied in oXygen an error and several warnings occur.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="appendix">
					<xsl:apply-templates select="attribute() | node()" mode="copyDocBook"/>
				</sqf:replace>
			</sqf:fix>
			
			<sqf:fix id="chapterToAppendix3">
				<sqf:description>
					<sqf:title>Convert chapter to appendix element. (Extension)</sqf:title>
					<sqf:p>An XSLT solution that uses a Saxon extension instruction to use the original file as source without attribute defaults being expanded at all.</sqf:p>
					<sqf:p>When being applied in oXygen the XIncludes seems to be resolved - so no xi:include element is present there.</sqf:p>
					<sqf:p>Furthermore, the whitespaces in the programlisting element are modified.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="appendix" select="sqfu:copy-content-of(.)"/>
			</sqf:fix>

		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>