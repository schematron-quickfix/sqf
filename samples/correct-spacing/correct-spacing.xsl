<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0" 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all">

	
	<xsl:template name="SplitElement">
		<xsl:param name="element"	as="element()"/>
		<xsl:param name="keepId"	as="xs:boolean"	select="true()"/>
		<xsl:param name="content"	as="node()*"	select="$element/node()"/>
		
		<xsl:variable name="SplitPos"	as="xs:integer?" 
			select="(for $i in 1 to count($content) return if (exists($content[$i]/self::text()[contains(., '&#x0A;')])) then $i else ())[1]"/>

		<xsl:choose>
			<xsl:when test="exists($SplitPos)">
				<xsl:variable name="splitContent1" as="node()+">
					<xsl:copy-of select="$content[$SplitPos > position()]"/>
					<xsl:value-of select="substring-before($content[$SplitPos], '&#x0A;')"/>
				</xsl:variable>
				<xsl:variable name="splitContent2" as="node()+">
					<xsl:value-of select="substring-after($content[$SplitPos], '&#x0A;')"/>
					<xsl:copy-of select="$content[position() > $SplitPos]"/>
				</xsl:variable>
				
				<xsl:call-template name="CreateElement">
					<xsl:with-param name="element"	select="$element"/>
					<xsl:with-param name="keepId"	select="$keepId"/>
					<xsl:with-param name="content"	select="$splitContent1"/>
				</xsl:call-template>
				
				<xsl:call-template name="SplitElement">
					<xsl:with-param name="element"	select="$element"/>
					<xsl:with-param name="keepId"	select="false()"/>
					<xsl:with-param name="content"	select="$splitContent2"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- No additional linebraek -> keep the rest of the content. -->
				<xsl:call-template name="CreateElement">
					<xsl:with-param name="element"	select="$element"/>
					<xsl:with-param name="keepId"	select="$keepId"/>
					<xsl:with-param name="content"	select="$content"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="CreateElement">
		<xsl:param name="element"	as="element()"/>
		<xsl:param name="keepId"	as="xs:boolean"/>
		<xsl:param name="content"	as="node()*"/>

		<xsl:element name="{name($element)}">
			<xsl:if test="$keepId">
				<xsl:copy-of select="$element/@id"/>
			</xsl:if>
			<xsl:copy-of select="$element/@* except $element/@id"/>
			<xsl:copy-of select="$content"/>
		</xsl:element>
	</xsl:template> 
		
</xsl:transform>
