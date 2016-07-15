<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:pattern>
    <!-- Table asserts -->
    <sch:rule context="table">
      <sch:let name="minColumsNo" value="min(//row/count(entry))"/>
      <sch:let name="reqColumsNo" value="max(//row/count(entry))"/>

      <!-- Check the number of cells on each row -->
      <sch:assert test="$minColumsNo >= $reqColumsNo" sqf:fix="addCells">Cells are missing. (The
        number of cells for each row must be <sch:value-of select="$reqColumsNo"/>)</sch:assert>

      <!-- Quick fix that adds the missing cells from a table. -->
      <sqf:fix id="addCells">
        <sqf:description>
          <sqf:title>Add enough empty cells on each row</sqf:title>
          <sqf:p>Add enough empty cells on each row to match the required number of cells.</sqf:p>
        </sqf:description>
        <sqf:add match="//row" position="last-child">
          <sch:let name="columnNo" value="count(entry)"/>
          <xsl:for-each select="1 to xs:integer($reqColumsNo - $columnNo)">
            <entry/>
            <xsl:text>
						</xsl:text>
          </xsl:for-each>
        </sqf:add>
      </sqf:fix>
    </sch:rule>

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

    <!-- Template used to copy the current node -->
    <xsl:template match="node() | @*" mode="copyExceptClass">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="node() | @*" mode="copyExceptClass"/>
      </xsl:copy>
    </xsl:template>
    <!-- Template used to skip the @class attribute from being copied -->
    <xsl:template match="@class" mode="copyExceptClass"/>

    <!-- Unordered list asserts -->
    <sch:rule context="ul">
      <!-- The list item must not end with semicolon -->
      <sch:report test="boolean(li[ends-with(text()[last()], ';')])" sqf:fix="removeSemicolon"
        role="warn"> Semicolon is not allowed after list item.</sch:report>

      <!-- Quick fix that removes the semicolon from every list item. -->
      <sqf:fix id="removeSemicolon">
        <sqf:description>
          <sqf:title>Remove semicolon</sqf:title>
        </sqf:description>
        <sqf:stringReplace match="li/text()[last()]" regex=";$"/>
      </sqf:fix>

      <!-- Check the level of nested lists -->
      <sch:report test="count(ancestor::ul) >= 2" sqf:fix="plain" role="error"> There are too many levels in
        this list </sch:report>

      <!-- Check that there is more that one lit item in a list -->
      <sch:assert test="count(li) > 1" sqf:fix="addLi plain" role="warn"> A list must have more than
        one item </sch:assert>

      <!-- Quick fix that converts a list into text -->
      <sqf:fix id="plain">
        <sqf:description>
          <sqf:title>Resolve the list into plain text</sqf:title>
          <sqf:p>The list will be converted into plain text.</sqf:p>
          <sqf:p>The text content of the list will be added as text.</sqf:p>
        </sqf:description>
        <sqf:replace match=". | .//ul">
          <xsl:apply-templates mode="copyExceptClass" select="li/node()"/>
        </sqf:replace>
      </sqf:fix>

      <!-- Quick fix that adds a new list item -->
      <sqf:fix id="addLi">
        <sqf:description>
          <sqf:title>Add new list item</sqf:title>
          <sqf:p>Add a new list item as last item in the list</sqf:p>
        </sqf:description>
        <sqf:add node-type="element" target="li" position="last-child"/>
      </sqf:fix>
    </sch:rule>
  </sch:pattern>
</sch:schema>
