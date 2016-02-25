<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	queryBinding="xslt2">
	
	<xsl:include href="handle-dita-attributes.xsl"/>
	
	<xsl:include href="../SqfUtil/sqfu-copy-of.xsl"/>
	
	<sch:ns uri="http://www.schematron-quickfix.com/utility" prefix="sqfu"/>
	
	<sch:pattern>
		<sch:rule context="section">
			
			<sch:report test="contains(lower-case(title), 'example')" role="warn" sqf:fix="sectionToExample1 sectionToExample2 sectionToExample3 sectionToExample4">
				For a section with 'Example' in its title use the specialized example element. 
			</sch:report>
			
			<sqf:fix id="sectionToExample1">
				<sqf:description>
					<sqf:title>Convert section to example element. (minimal)</sqf:title>
					<sqf:p>Version with minimal code. It has the drawback that the class attribute of the section will be copied as well overwriting the default for the new example element.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="example" select="attribute() | node()" xml:space="preserve"/>
			</sqf:fix>
			
			<sqf:fix id="sectionToExample2">
				<sqf:description>
					<sqf:title>Convert section to example element. (minimal fixed)</sqf:title>
					<sqf:p>Version with minimal but correct code. It does not copy the @class of the section element but still expands all other attribute defaults.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="example" select="attribute() except @class, node()" xml:space="preserve"/>
			</sqf:fix>
			
			<sqf:fix id="sectionToExample3">
				<sqf:description>
					<sqf:title>Convert section to example element. (XSLT)</sqf:title>
					<sqf:p>An XSLT solution that recursively processes the content and keeps @class and namespace declarations from being copied.</sqf:p>
					<sqf:p>Since the @type attribute might be set explicitly it can't be hidden completely and, thus, is expanded always.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="example" xml:space="preserve">
					<xsl:apply-templates select="attribute() | node()" mode="copyDita"/>
				</sqf:replace>
			</sqf:fix>
			
			<sqf:fix id="sectionToExample4">
				<sqf:description>
					<sqf:title>Convert section to example element. (Extension)</sqf:title>
					<sqf:p>An XSLT solution that uses a Saxon extension instruction to use the original file as source without attribute defaults being expanded at all.</sqf:p>
				</sqf:description>
				<sqf:replace match="." node-type="keep" target="example" select="sqfu:copy-content-of(.)" xml:space="preserve"/>
			</sqf:fix>

		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>