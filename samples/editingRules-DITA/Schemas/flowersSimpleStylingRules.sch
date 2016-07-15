<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:pattern>

    <!-- Title - styling elements are not allowed in title. -->
    <sch:rule context="title/b">
      <sch:report test="true()" sqf:fix="resolveBold" role="warn"> Bold element is not allowed in
        title.</sch:report>

      <!-- Quick fix that converts a bold element into text -->
      <sqf:fix id="resolveBold">
        <sqf:description>
          <sqf:title>Change the bold element into text</sqf:title>
          <sqf:p>Removes the bold (b) markup and keeps the text content.</sqf:p>
        </sqf:description>
        <sqf:replace select="text()"/>
      </sqf:fix>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern>
    <!-- Ordered list assert -->
    <sch:rule context="ol">
      <sch:assert test="false()" sqf:fix="convertOLinUL" role="error"> Ordered lists are not
        allowed, use unordered lists instead.</sch:assert>

      <!-- Quick fix that converts an ordered list into an unordered one. -->
      <sqf:fix id="convertOLinUL">
        <sqf:description>
          <sqf:title>Convert ordered list to unordered list</sqf:title>
        </sqf:description>
        <sqf:replace target="ul" node-type="element">
          <xsl:apply-templates mode="copyExceptClass" select="@* | node()"/>
        </sqf:replace>
      </sqf:fix>
    </sch:rule>

    <sch:rule context="li">
      <!-- The list item must not end with semicolon -->
      <sch:report test="boolean(ends-with(text()[last()], ';'))" sqf:fix="removeSemicolon replaceSemicolon"
        role="warn"> Semicolon is not allowed after list item.</sch:report>
      
      <!-- Quick fix that removes the semicolon from list item. -->
      <sqf:fix id="removeSemicolon">
        <sqf:description>
          <sqf:title>Remove semicolon</sqf:title>
        </sqf:description>
        <sqf:stringReplace match="text()[last()]" regex=";$"/>
      </sqf:fix>
      
      <!-- Quick fix that replace the semicolon with full stop (.). -->
      <sqf:fix id="replaceSemicolon" use-when="position() = last()">
        <sqf:description>
          <sqf:title>Replace semicolon with full stop</sqf:title>
        </sqf:description>
        <sqf:stringReplace match="text()[last()]" regex=";$" select="'.'"/>
      </sqf:fix>
    </sch:rule>
  </sch:pattern>
   
  <!-- Report if link same as @href test value -->
  <sch:pattern>
    <sch:rule context="*[contains(@class, ' topic/xref ') or contains(@class, ' topic/link ')]">
      <sch:report test="@scope='external' and @href=text()" sqf:fix="removeText" role="warn">
        Link text is same as @href attribute value. Please remove.
      </sch:report>
      <sqf:fix id="removeText">
        <sqf:description>
          <sqf:title>Remove redundant link text, text is same as @href value.</sqf:title>
        </sqf:description>
        <sqf:delete match="text()"/>
      </sqf:fix>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern>
    <!-- The text is not allowed directly in the section, it should be in a paragraph. Otherwise the output will be rendered with no space after the section -->
    <sch:rule context="*[contains(@class, ' topic/section ')]/text()[string-length(normalize-space(.)) > 0]">
      <sch:report test="true()" role="warn" subject="child::node()[1]" sqf:fix="wrapInParagraph">
        The text in a section element should be in a paragraph.</sch:report>
      
      <!-- Wrap the current element in a paragraph. -->
      <sqf:fix id="wrapInParagraph">
        <sqf:description>
          <sqf:title>Wrap text in a paragraph</sqf:title>
        </sqf:description>
        <sqf:replace node-type="element" target="p">
          <xsl:apply-templates mode="copyExceptClass" select="."/>
        </sqf:replace>
        <sqf:delete/>
      </sqf:fix>
    </sch:rule>
  </sch:pattern>
  
  <!-- Template used to copy the current node -->
  <xsl:template match="node() | @*" mode="copyExceptClass">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*" mode="copyExceptClass"/>
    </xsl:copy>
  </xsl:template>
  <!-- Template used to skip the @class attribute from being copied -->
  <xsl:template match="@class" mode="copyExceptClass"/>
  
</sch:schema>
