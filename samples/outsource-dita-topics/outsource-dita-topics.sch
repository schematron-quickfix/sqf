<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	xmlns:sqfs	= "http://www.schematron-quickfix.com/sample"
	queryBinding="xslt2">
	
	
	<xsl:include href="outsource-dita-topics.xsl"/>
	
	
	<sch:ns uri="http://www.schematron-quickfix.com/utility" 	prefix="sqfu"/>
	<sch:ns uri="http://www.schematron-quickfix.com/sample" 	prefix="sqfs"/>
	
	
	<sch:pattern>
		<sch:rule context="*[contains(@class, ' topic/topic ')]">
			
			<sch:report test="ancestor::*[contains(@class, ' topic/topic ')]" role="warn" sqf:fix="outsourceTopic">
				Topic <sch:value-of select="count(preceding-sibling::*[contains(@class, ' topic/topic ')]) + 1"/> '<sch:value-of select="title"/>' should be placed in its own file and referenced within the DITA map.
			</sch:report>
			
			<sqf:fix id="outsourceTopic">
				
				<sqf:description>
					<sqf:title>Outsource all topics in individual files.</sqf:title>
					<sqf:p>Generates a new file for each child topic.</sqf:p>
					<sqf:p>This version is not working in oXygen, since it currently can't handle XIncludes within SQF correctly.</sqf:p>
				</sqf:description>
				
				<sch:let name="parent"		value="parent::*"/>
				<sch:let name="topicUri"	value="base-uri()"/>
				<sch:let name="ditaMapUrl"	value="sqfs:getDitaMapUrl($topicUri)"/>
				
				<sqf:replace match="parent::*/*[contains(@class, ' topic/topic ')]">
					<xsl:call-template name="oursourceTopic"/>
				</sqf:replace>
				
				<sqf:add match="doc($ditaMapUrl)//*[resolve-uri(@href) = $topicUri]">
					<xsl:call-template name="insertTopicref">
						<xsl:with-param name="parent" select="$parent"/>
					</xsl:call-template>
				</sqf:add>

			</sqf:fix>
			
		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>