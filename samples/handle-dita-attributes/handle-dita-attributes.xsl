<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:template match="document-node() | element()" mode="copyDita">
		<xsl:copy>
			<xsl:apply-templates select="attribute() | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="attribute() | text() | comment() | processing-instruction()" mode="copyDita">
		<xsl:copy/>
	</xsl:template>
	
	<xsl:template match="@class | @domains" mode="copyDita">
		<!-- don't copy these elements since they are always set as defaults in the schema -->
	</xsl:template>
		
</xsl:stylesheet>