<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:gui	= "http://www.dita-semia.org/xslt-gui"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:variable name="BUTTON_OK" 		as="xs:string" select="'OK'"/>
	<xsl:variable name="BUTTON_CANCEL" 	as="xs:string" select="'Cancel'"/>
	
	<xsl:template name="editTextContent">
		
		<xsl:sequence select="attribute()"/>	<!-- always keep the attributes -->
		<xsl:variable name="htmlResult">
			<gui:html-dialog title="HTML Dialog" size="(200, 130)">
				<p>Edit the text:</p>
				<input type="text" name="text" size="200" value="{.}"/>
			</gui:html-dialog>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$htmlResult/button = $BUTTON_OK">
				<xsl:value-of select="$htmlResult/text"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="node()"/> <!-- Keep the current content. -->
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- 
		the following code is not working, but why???
		behavior: the first xsl:when within xsl:choose won't be used when pressing OK!?
	-->
	<xsl:template name="editTextContent2">
		<xsl:variable name="htmlResult" as="element()*">
			<gui:html-dialog title="HTML Dialog" size="(200, 130)">
				<p>Edit the text:</p>
				<input type="text" name="text" size="200" value="{.}"/>
			</gui:html-dialog>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$htmlResult/self::button = $BUTTON_OK">
				<xsl:value-of select="$htmlResult/self::text"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>