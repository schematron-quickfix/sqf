<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:java	= "java:org.sqf.util.StaticFct"
	exclude-result-prefixes="#all"
	version="2.0">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">

		<Wrapper>
			<xsl:text>&#x0A;   </xsl:text>
			<xsl:comment> Resolved: </xsl:comment>
			<xsl:text>&#x0A;</xsl:text>
			<xsl:sequence select="."/>
			<xsl:comment> Raw: </xsl:comment>
			<xsl:sequence select="java:loadDocRaw(base-uri())"/>
		</Wrapper>

	</xsl:template>
	
</xsl:stylesheet>