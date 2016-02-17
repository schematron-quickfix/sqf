<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	queryBinding="xslt2">
	
	<xsl:variable name="MAX_SHORTDESC_LEN" 			as="xs:integer" select="400"/>
	<xsl:variable name="IGNORE_SHORTDESC_TOO_LONG" 	as="processing-instruction()">
		<xsl:processing-instruction name="suppress-warning" select="'shortdesc-too-long'"/>
	</xsl:variable>
	

	<sch:pattern>
		<sch:rule context="node()[ancestor-or-self::node()[processing-instruction('suppress-warning')[contains(., 'shortdesc-too-long')]]]">
			<!-- ignore all content of nodes marked to ignore this kind of error -->
		</sch:rule>
		<sch:rule context="*[contains(@class, ' topic/shortdesc ')]">
			
			<sch:let name="length" value="string-length(normalize-space(.))"/>
			<sch:report test="$length > $MAX_SHORTDESC_LEN" role="warn" sqf:fix="ignoreShortdescTooLongElement ignoreShortdescTooLongTopic ignoreShortdescTooLongElement ignoreShortdescTooLongFile">
				The short description should not contain more than <sch:value-of select="$MAX_SHORTDESC_LEN"/> characters. Current length: <sch:value-of select="$length"/>.
			</sch:report>
			
			<sqf:fix id="ignoreShortdescTooLongElement">
				<sqf:description>
					<sqf:title>Ignore this warning only for this shortdesc element.</sqf:title>
				</sqf:description>
				<sqf:add match="." position="first-child" select="$IGNORE_SHORTDESC_TOO_LONG"/>
			</sqf:fix>
			
			<sqf:fix id="ignoreShortdescTooLongTopic">
				<sqf:description>
					<sqf:title>Ignore this warning for the current topic.</sqf:title>
				</sqf:description>
				<sqf:add match="ancestor::*[contains(@class, ' topic/topic ')][1]" position="first-child" select="$IGNORE_SHORTDESC_TOO_LONG"/>
			</sqf:fix>
			
			<sqf:fix id="ignoreShortdescTooLongFile">
				<sqf:description>
					<sqf:title>Ignore this warning for the whole file.</sqf:title>
				</sqf:description>
				<sqf:add match="/*" position="before" select="$IGNORE_SHORTDESC_TOO_LONG"/>
			</sqf:fix>
			
		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>