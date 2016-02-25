<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:xi	= "http://www.w3.org/2001/XInclude"
	xmlns:xia	= "http://www.w3.org/2001/XInclude/alias"
	xmlns:db	= "http://docbook.org/ns/docbook"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	xmlns:sqfs	= "http://www.schematron-quickfix.com/sample"
	xmlns:gui	= "http://www.dita-semia.org/xslt-gui"
	exclude-result-prefixes="#all"
	version="2.0">
	
	
	<xsl:include href="../SqfUtil/sqfu-copy-of.xsl"/>
	
	
	<xsl:namespace-alias stylesheet-prefix="xia" result-prefix="xi"/>
	
	
	
	<xsl:variable name="BUTTON_OK" 		as="xs:string" select="'OK'"/>
	<xsl:variable name="BUTTON_CANCEL" 	as="xs:string" select="'Cancel'"/>
	
	
	<xsl:function name="sqfs:getFilenames" as="xs:string*">
		<xsl:param name="book" as="element()"/>
		
		<xsl:variable name="htmlResult">
			<gui:html-dialog title="HTML Dialog" size="(430, 300)" buttons="($BUTTON_OK, $BUTTON_CANCEL)">
				<table cellpadding="1">
					<thead>
						<tr style="font-weight: bold">
							<td>#</td>
							<td>Title</td>
							<td>Filename</td>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$book/db:chapter">
							<xsl:variable name="title" 		as="xs:string" select="db:title"/>
							<tr>
								<td>
									<xsl:value-of select="position()"/>
								</td>
								<td>
									<xsl:value-of select="$title"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="@xml:base">
											<label>
												<xsl:value-of select="@xml:base"/>
											</label>
										</xsl:when>
										<xsl:otherwise>
											<input 
												type	= "text" 
												size	= "30"
												name 	= "filename"
												value	= "{replace(lower-case($title), '\s+', '-')}.xml"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</gui:html-dialog>
		</xsl:variable>
		
		<xsl:message select="$htmlResult"/>
		
		<xsl:choose>
			<xsl:when test="$htmlResult/button = $BUTTON_OK">
				<xsl:for-each select="$htmlResult/filename">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">Abort by user.</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<xsl:template name="oursourceChapter" as="element()">
		<xsl:param name="filenames"	as="xs:string*"/>
		<xsl:param name="fake" 		as="xs:boolean"	select="false()"/>

		<xsl:variable name="pos" 		as="xs:integer" select="count(current()/preceding-sibling::db:chapter[string(@xml:base) = ''])"/>
		<xsl:variable name="filename" 	as="xs:string" 	select="$filenames[$pos + 1]"/>

		<xsl:result-document href="{resolve-uri($filename)}" method="xml">
			<xsl:text>&#x0A;</xsl:text>
			<xsl:sequence select="sqfu:copy-of(.)"/>
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