<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:my	= "http://www.schematron-quickfix.com/sample/add-id"
	queryBinding="xslt2">
	
	
	<sch:let name="ID_CLASS_LIST" value="('topic/p', 'topic/section')"/>
	
	<sch:ns uri="http://www.schematron-quickfix.com/sample/add-id" prefix="my"/>
	
	<xsl:function name="my:createId" as="xs:NCName">
		<xsl:param name="element"	as="element()"/>
		
		<xsl:value-of select="concat(name($element), '_', generate-id($element))"/>
	</xsl:function>

	<sch:pattern>
		<sch:rule context="*[tokenize(@class, '\s+')[. = $ID_CLASS_LIST]]">
			
			<sch:report test="string(@id) = ''" role="warn" sqf:fix="addIdElement addIdFile">
				The <sch:value-of select="name()"/> element should have an id attribute.
			</sch:report>
			
			<sqf:fix id="addIdElement">
				<sqf:description>
					<sqf:title>Add id attribute to this element.</sqf:title>
				</sqf:description>
				<sqf:delete match="@id"/>
				<sqf:add 
					match		= "." 
					node-type	= "attribute" 
					target		= "id" 
					select		= "my:createId(.)"/>
			</sqf:fix>
			
			<sqf:fix id="addIdFile">
				<sqf:description>
					<sqf:title>Add all missing id attributes in this file.</sqf:title>
				</sqf:description>
				<sqf:add 
					match		= "//*[tokenize(@class, '\s+')[. = $ID_CLASS_LIST]][string(@id) = '']" 
					node-type	= "attribute" 
					target		= "id" 
					select		= "my:createId(.)"/>
			</sqf:fix>

		</sch:rule>
	</sch:pattern>
	
</sch:schema>