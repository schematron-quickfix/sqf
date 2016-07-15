<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns uri="http://www.oxygenxml.com/customFunction" prefix="oxyF"/>
  <sch:pattern>
    <!-- Report cases when the lines in a codeblock exceeds 80 characters -->
    <sch:rule context="*[contains(@class, ' pr-d/codeblock ')]" role="warn">
      <sch:let name="offendingLines" value="oxyF:lineLengthCheck(string(), 80)"/>
      <sch:report test="string-length($offendingLines) > 0">
        Lines in codeblocks should not exceed 80 characters. 
        (<sch:value-of select="$offendingLines"/>) </sch:report>
    </sch:rule>
  </sch:pattern>
  
  <!-- Template that breaks a text into its composing lines of text -->
  <xsl:function name="oxyF:lineLengthCheck" as="xs:string">
    <xsl:param name="textToBeChecked" as="xs:string"/>
    <xsl:param name="maxLength" as="xs:integer"/>
    <xsl:value-of>
      <xsl:for-each select="tokenize($textToBeChecked, '\n')">
        <xsl:if test="string-length(current()) > $maxLength">
          <xsl:value-of select="concat('line ', position(), ' has ', string-length(current()), ' characters, ') "/>
        </xsl:if>
      </xsl:for-each>
    </xsl:value-of>
  </xsl:function>
</sch:schema>
