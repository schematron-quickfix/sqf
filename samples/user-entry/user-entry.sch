<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	queryBinding="xslt2">
	
	<xsl:variable name="MAX_LEN" as="xs:integer" select="10"/>

	<sch:pattern>
		<sch:rule context="Element">
			
			<sch:report test="string-length(.) > $MAX_LEN" sqf:fix="editTextContent">
				The element should not contain more than <sch:value-of select="$MAX_LEN"/> characters.
			</sch:report>
			
			<sqf:fix id="editTextContent">
				<sqf:description>
					<sqf:title>Edit the text content.</sqf:title>
				</sqf:description>
				<sqf:user-entry name="textContent" default="{.}">
					<sqf:description>
						<sqf:title>Edit the text:</sqf:title>
					</sqf:description>
				</sqf:user-entry>
				<sqf:replace match="node()" select="$textContent"/>
			</sqf:fix>
		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>