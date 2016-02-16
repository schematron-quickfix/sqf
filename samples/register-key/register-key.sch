<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:my	= "http://www.schematron-quickfix.com/sample/register-key"
	queryBinding="xslt2">
	
	
	<xsl:variable name="KEY_LIST_PATH" as="xs:string" select="'key-list.xml'"/>
	
	
	<sch:ns uri="http://www.schematron-quickfix.com/sample/register-key" prefix="my"/>
	
	<sch:pattern>
		<sch:rule context="Condition/Key">
			
			<sch:assert test="my:existsKey(.)" role="warn" sqf:fix="registerKey">
				The key '<sch:value-of select="."/>' is not registered yet.
			</sch:assert>
			
			<sqf:fix id="registerKey">
				<sqf:description>
					<sqf:title>Add key '<sch:value-of select="."/>' to list.</sqf:title>
				</sqf:description>
				<sch:let name="key" value="."/>
				
				<!-- insert before 1st element with a key greater than the new one. -->
				<sqf:add 
					match		= "doc($KEY_LIST_PATH)/KeyList/Key[text() > $key][1]" 
					position	= "before"
					use-when	= "exists(doc($KEY_LIST_PATH)/KeyList/Key[text() > $key])">
					<Key>
						<sch:value-of select="$key"/>
					</Key>
					<xsl:text>&#x0A;  </xsl:text>
				</sqf:add>
				
				<!-- or insert at the end, if no such key exists. -->
				<sqf:add 
						match		= "doc($KEY_LIST_PATH)/KeyList" 
						position	= "last-child"
						use-when	= "empty(doc($KEY_LIST_PATH)/KeyList/Key[text() > $key])">
					<Key>
						<sch:value-of select="$key"/>
					</Key>
					<xsl:text>&#x0A;</xsl:text>
				</sqf:add>
			</sqf:fix>
			
		</sch:rule>
		
	</sch:pattern>
	
	
	
	<xsl:key name="Key" match="Key" use="."/>
	
	
	<xsl:function name="my:existsKey" as="xs:boolean">
		<xsl:param name="key"	as="xs:string"/>
		
		<xsl:sequence select="exists(key('Key', $key, doc($KEY_LIST_PATH)))"/>
	</xsl:function>
	
	
</sch:schema>