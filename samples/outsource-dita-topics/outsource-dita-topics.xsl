<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:db	= "http://docbook.org/ns/docbook"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	xmlns:sqfs	= "http://www.schematron-quickfix.com/sample"
	exclude-result-prefixes="#all"
	version="2.0">
	
	
	<xsl:include href="../SqfUtil/sqfu-copy-of.xsl"/>
	
	<!--<xsl:template match="/">
		<xsl:message select="sqfs:getDitaMapUrl(base-uri())"/>
	</xsl:template>-->
	
	<xsl:template name="oursourceTopic">
		<xsl:variable name="filename" 	as="xs:string" select="sqfs:getFileName(.)"/>

		<xsl:result-document href="{resolve-uri($filename)}" method="xml">
			<xsl:text>&#x0A;</xsl:text>
			<xsl:for-each select="/processing-instruction('xml-model')">
				<xsl:copy-of select="."/>
				<xsl:text>&#x0A;</xsl:text>
			</xsl:for-each>
			<xsl:sequence select="sqfu:copy-of(.)"/>
		</xsl:result-document>

	</xsl:template>
	
	
	<xsl:template name="insertTopicref" as="element()*">
		<xsl:param name="parent" as="element()"/>
		
		<xsl:for-each select="$parent/*[contains(@class, ' topic/topic ')]">
			<topicref href="{sqfs:getFileName(.)}"/>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:function name="sqfs:getDitaMapUrl" as="xs:string?">
		<xsl:param name="topicUri" as="xs:anyURI"/>
		
		<xsl:variable name="mapList" as="document-node()*"	select="collection(concat(resolve-uri('./', $topicUri), '?select=*.ditamap'))"/>
		<xsl:variable name="refList" as="attribute()*"		select="$mapList//@href[resolve-uri(.) = $topicUri]"/>
		<xsl:value-of select="base-uri($refList[1])"/>
	</xsl:function>
	
	
	<xsl:function name="sqfs:getFileName" as="xs:string">
		<xsl:param name="topic" as="element()"/>
		
		<xsl:sequence select="concat(replace(lower-case($topic/title), '\s+', '-'), '.dita')"/>
	</xsl:function>
		
</xsl:stylesheet>