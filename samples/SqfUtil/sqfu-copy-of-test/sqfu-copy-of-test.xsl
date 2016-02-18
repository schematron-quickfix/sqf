<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	xmlns:sqfu	= "http://www.schematron-quickfix.com/utility"
	exclude-result-prefixes="#all"
	version="2.0">

	<xsl:include href="../sqfu-copy-of.xsl"/>

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">

		<Wrapper>
			<xsl:text>&#x0A;  </xsl:text>
			<xsl:comment> copy of document node: </xsl:comment>
			<xsl:text>&#x0A;  </xsl:text>
			<xsl:sequence select="sqfu:copy-of(.)"/>
			
			
			<xsl:text>&#x0A;  </xsl:text>
			<xsl:comment> copy of root element: </xsl:comment>
			<xsl:text>&#x0A;  </xsl:text>
			<xsl:sequence select="sqfu:copy-of(*)"/>
			
			<xsl:text>&#x0A;  </xsl:text>
			<xsl:comment> copy of all elements: </xsl:comment>
			<xsl:text>&#x0A;  </xsl:text>
			<Wrapper>
				<xsl:sequence select="sqfu:copy-of(*/*)"/>
			</Wrapper>

			<xsl:text>&#x0A;  </xsl:text>
			<xsl:comment> copy of all elements with default-value as attribute: </xsl:comment>
			<xsl:text>&#x0A;  </xsl:text>
			<Wrapper>
				<xsl:sequence select="sqfu:copy-of(*/*[@attribute = 'default-value'])"/>
			</Wrapper>
			<xsl:text>&#x0A;</xsl:text>
		</Wrapper>
		
	</xsl:template>
	
</xsl:stylesheet>