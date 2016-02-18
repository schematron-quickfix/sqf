<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:java	= "java:org.sqf.util.StaticFct"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	exclude-result-prefixes="#all"
	version="3.0">

	<!--
		Creates a copy of the original content (without expanded attribute defaults)
		Only works for items being part of a document node with a well defined base-uri.
		In all other cases a copy of the passed content will be returned.
		
		Currently there is no caching of the raw doc.
	-->
	<xsl:function name="sqfu:copy-of" as="item()*">
		<xsl:param name="content" as="item()*"/>

		<xsl:for-each select="$content">
			<xsl:variable name="baseUri"	as="xs:anyURI?" 		select="base-uri()"/>
			<xsl:variable name="docRaw" 	as="document-node()?" 	select="if (exists($baseUri)) then java:loadDocRaw($baseUri) else ()"/>
			<xsl:choose>
				<xsl:when test="exists($docRaw)">
					<xsl:variable name="raw" as="item()?" select="sqfu:getFromRaw(., $docRaw)"/>
					<xsl:if test="exists($raw)">
						<xsl:copy-of select="if (exists($raw)) then $raw else ." copy-namespaces="no"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<!-- no base-uri or it could not be loaded -> pass through content -->
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	
	<xsl:function name="sqfu:getFromRaw" as="item()?">
		<xsl:param name="content" 	as="item()"/>
		<xsl:param name="docRaw"	as="document-node()"/>
		
		<xsl:choose>
			<xsl:when test="$content instance of document-node()">
				<xsl:sequence select="$docRaw"/>
			</xsl:when>
			<xsl:when test="($content instance of attribute()) and (exists($content/parent::*))">
				<xsl:variable name="rawParent" as="element()?" select="sqfu:getFromRaw($content/parent::*, $docRaw)"/>
				<xsl:sequence select="$rawParent/attribute()[name() = name($content)]"/>
				<!-- return the attribute from the corresponding raw element -->
			</xsl:when>
			<xsl:when test="($content instance of node()) and (exists($content/parent::node()))">
				<xsl:variable name="rawParent" as="node()?" select="sqfu:getFromRaw($content/parent::node(), $docRaw)"/>
				<xsl:if test="empty($rawParent)">
					<xsl:message>no parent for node '<xsl:value-of select="node-name($content)"/>'</xsl:message>
				</xsl:if>
				<xsl:if test="exists($rawParent)">
					<xsl:variable name="nodePos" 		as="xs:integer" select="count($content/preceding-sibling::node()) + 1"/>
					<xsl:variable name="rawCandidate"	as="item()?"	select="$rawParent/child::node()[$nodePos]"/>
					<xsl:if test="node-name($content) = node-name($rawCandidate)">
						<!-- same node-name -> assume the raw node was found -->
						<xsl:sequence select="$rawCandidate"/>
					</xsl:if>
				</xsl:if>
				<xsl:sequence select="$rawParent/attribute()[name() = name($content)]"/>
				<!-- return the attribute from the corresponding raw element -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>no match for node <xsl:value-of select="node-name($content)"/></xsl:message>
				<!-- no match -> return nothing -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
</xsl:stylesheet>