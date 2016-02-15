<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	queryBinding="xslt2">
	
	<sch:pattern>
		<sch:rule context="sl">
			<!-- previous node is either an element or non-space-only text --> 
			<sch:let name="previousNode" value="preceding-sibling::node()[self::text()[not(matches(., '^\s+$'))] | self::*][1]"/>
			
			<sch:report test="$previousNode/self::sl" role="warn" sqf:fix="mergeSlElement">
				The sl element directly follows another sl element.
			</sch:report>
			
			<sqf:fix id="mergeSlElement">
				<sqf:description>
					<sqf:title>integrate the sl element into the previous one.</sqf:title>
				</sqf:description>
				<sqf:add match="preceding-sibling::sl[1]" position="last-child" select="node()"/>
				<sqf:delete match="."/>
			</sqf:fix>

		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>