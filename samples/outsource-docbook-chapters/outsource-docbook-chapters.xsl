<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:xi	= "http://www.w3.org/2001/XInclude"
	xmlns:xia	= "http://www.w3.org/2001/XInclude/alias"
	xmlns:db	= "http://docbook.org/ns/docbook"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	exclude-result-prefixes="#all"
	version="2.0">
	
	
	<xsl:include href="../SqfUtil/sqfu-copy-of.xsl"/>
	
	
	<xsl:namespace-alias stylesheet-prefix="xia" result-prefix="xi"/>
	
	
	<xsl:template name="oursourceChapter" as="element()">
		<xsl:param name="fake" 		as="xs:boolean"	select="false()"/>

		<xsl:variable name="filename" 	as="xs:string" 	select="concat(replace(lower-case(db:title), '\s+', '-'), '.xml')"/>

		<xsl:result-document href="{resolve-uri($filename)}" method="xml">
			<xsl:text>&#x0A;</xsl:text>
			<xsl:for-each select="/processing-instruction('xml-model')">
				<xsl:copy-of select="."/>
				<xsl:text>&#x0A;</xsl:text>
			</xsl:for-each>
			<xsl:copy copy-namespaces="no">
				<xsl:copy-of select="/*/@version"/>
				<xsl:sequence select="sqfu:copy-content-of(.)"/>
			</xsl:copy>
		</xsl:result-document>

		<xsl:choose>
			<xsl:when test="$fake">
				<xia:Include href="{$filename}"/>
			</xsl:when>
			<xsl:otherwise>
				<xia:include href="{$filename}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
</xsl:stylesheet>