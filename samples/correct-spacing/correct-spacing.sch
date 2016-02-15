<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:sch	= "http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf	= "http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xs	= "http://www.w3.org/2001/XMLSchema"
	queryBinding="xslt2">
	
	<xsl:include href="correct-spacing.xsl"/>

	<sch:pattern>
		
		<sch:rule context="*[contains(@class, ' pr-d/codeblock ')]">
			<!-- within codeblocks it's ok to format the context with whitespaces -->
		</sch:rule>
		
		<sch:rule context="*[@xml:space = 'preserve']">
			
			<sch:report 
					test	= "node()[1][self::text()][matches(., '^\s')][not(contains(parent::*/@class, 'topic/ph'))]" 
					role	= "warning" 
					sqf:fix	= "removeLeadingWhitespace normalizeWhitespaces">
				The <sch:value-of select="name()"/> element should not contain leading whitespaces.
			</sch:report>
			
			<sch:report 
					test	= "node()[last()][self::text()][matches(., '\s$')][not(contains(parent::*/@class, 'topic/ph'))]" 
					role	= "warning" 
					sqf:fix	= "removeTrailingWhitespace normalizeWhitespaces">
				The <sch:value-of select="name()"/> should not contain trailing whitespaces.
			</sch:report>
			
			<sch:report 
					test	= "text()[matches(., '\n')]" 
					role	= "warning" 
					sqf:fix	= "removeLinebreaks splitElementOnNewline normalizeWhitespaces">
				The <sch:value-of select="name()"/> should not contain linebreaks.
			</sch:report>
			
			<sch:report 
					test	= "text()[matches(., '\s\s+')]" 
					role	= "warning" 
					sqf:fix	= "removeMultipleWhitespaces normalizeWhitespaces">
				The <sch:value-of select="name()"/> element should not contain multiple consecutive whitespaces
				(marked by '***[]***'): '<sch:value-of select="for $i in text()[matches(., '\s\s+')] return replace($i, '(\s\s+)', '***[$1]***')"/>'
			</sch:report>
			
			<sqf:fix id="removeLeadingWhitespace">
				<sqf:description>
					<sqf:title>Remove leading whitespaces.</sqf:title>
				</sqf:description>
				<sqf:stringReplace match="text()[1]" regex="^\s+" select="''"/>
			</sqf:fix>
			
			<sqf:fix id="removeTrailingWhitespace">
				<sqf:description>
					<sqf:title>Remove trailing whitespaces.</sqf:title>
				</sqf:description>
				<sqf:stringReplace match="text()[last()]" regex="\s+$" select="''"/>
			</sqf:fix>
			
			<sqf:fix id="removeLinebreaks">
				<sqf:description>
					<sqf:title>Replace linebreaks by spaces.</sqf:title>
				</sqf:description>
				<sqf:stringReplace match="text()" regex="\s*\n\s*" select="' '"/>
			</sqf:fix>
			
			<sqf:fix id="splitElementOnNewline" use-when="exists(self::p | self::sli)">
				<sqf:description>
					<sqf:title>Split <sch:value-of select="name(.)"/> element on linebreaks.</sqf:title>
				</sqf:description>
				<sqf:replace match=".">
					<xsl:call-template name="SplitElement">
						<xsl:with-param name="element" select="."/>
					</xsl:call-template>
				</sqf:replace>
			</sqf:fix>
			
			<sqf:fix id="removeMultipleWhitespaces">
				<sqf:description>
					<sqf:title>Remove multiple whitespaces.</sqf:title>
				</sqf:description>
				<sqf:stringReplace match="text()" regex="\s\s+" select="' '"/>
			</sqf:fix>
			
			<sqf:fix id="normalizeWhitespaces">
				<sqf:description>
					<sqf:title>Normalize all whitespaces.</sqf:title>
				</sqf:description>
				<sqf:replace match="." select="normalize-space(.)"/>
			</sqf:fix>
			
		</sch:rule>
		
	</sch:pattern>
	
</sch:schema>