<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:xi	= "http://www.w3.org/2001/XInclude"
	xmlns:xia	= "http://www.w3.org/2001/XInclude/alias"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:namespace-alias stylesheet-prefix="xia" result-prefix="xi"/>
	
	<xsl:template match="document-node() | element()" mode="copyDocBook">
		<xsl:copy>
			<xsl:apply-templates select="attribute() | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="attribute() | text() | comment() | processing-instruction()" mode="copyDocBook">
		<xsl:copy/>
	</xsl:template>
	
	<xsl:template match="*[@xml:base]" mode="copyDocBook">
		<xia:include>
			<xsl:attribute name="href" select="@xml:base"/>
		</xia:include>
	</xsl:template>
	
	<xsl:template match="processing-instruction('xml-model')" mode="copyDocBook">
		<!-- don't copy these PIs since they are (most likely) part of an xincluded file --> 
	</xsl:template>
		
</xsl:stylesheet>