<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Topic ID must be equal to name -->
    <sch:pattern>
      <sch:rule context="/*[1][contains(@class, ' topic/topic ')]">
        <sch:let name="reqId" value="replace(tokenize(document-uri(/), '/')[last()], '\.xml', '')"/>
        <sch:assert test="@id = $reqId" sqf:fix="setId">
          Topic ID must be equal to file name.
        </sch:assert>
        <sqf:fix id="setId">
          <sqf:description>
            <sqf:title>Set "<sch:value-of select="$reqId"/>" as a topic ID</sqf:title>
            <sqf:p>The topic ID must be equal to the file name.</sqf:p>
          </sqf:description>
          <sqf:add node-type="attribute" target="id" select="$reqId"/>
        </sqf:fix>
      </sch:rule>
    </sch:pattern>
  
   <!-- Add Ids to all sections, in this way you can easly refer the section from documentation -->
   <sch:pattern>
     <sch:rule context="*[contains(@class, ' topic/section ') and not(contains(@class, ' task/')) and not(contains(@class, ' glossentry/'))]">
       <sch:assert test="@id" sqf:fix="addId addIds" role="warn">All sections should have an @id attribute</sch:assert>
       
       <sqf:fix id="addId">
         <sqf:description>
           <sqf:title>Add @id to the current section</sqf:title>
           <sqf:p>Add an @id attribute to the current section. The ID is generated from the section title.</sqf:p>
         </sqf:description>
         
         <!-- Generate an id based on the section title. If there is no title then generate a random id. -->
         <sqf:add target="id" node-type="attribute"
           select="if (exists(title) and string-length(title) > 0) 
           then substring(lower-case(replace(replace(normalize-space(string(title)), '\s', '_'), '[^a-zA-Z0-9_]', '')), 0, 50) 
           else generate-id()"/>
       </sqf:fix>
       
       <sqf:fix id="addIds">
         <sqf:description>
           <sqf:title>Add @id to all sections</sqf:title>
           <sqf:p>Add an @id attribute to each section from the document. The ID is generated from the section title.</sqf:p>
         </sqf:description>
         <!-- Generate an id based on the section title. If there is no title then generate a random id. -->
         <sqf:add match="//section[not(@id)]" target="id" node-type="attribute" 
           select="if (exists(title) and string-length(title) > 0) 
           then substring(lower-case(replace(replace(normalize-space(string(title)), '\s', '_'), '[^a-zA-Z0-9_]', '')), 0, 50) 
           else generate-id()"/>
       </sqf:fix>
     </sch:rule>
   </sch:pattern>
  
  
  <sch:pattern>
    <!-- Report ul after ul -->
    <sch:rule context="*[contains(@class, ' topic/ul ')]">
      <sch:report test="following-sibling::element()[1][contains(@class, ' topic/ul ')]" role="warn" sqf:fix="mergeLists"> Two
        consecutive unordered lists. You can probably merge them into one. </sch:report>
    
      <sqf:fix id="mergeLists">
        <sqf:description>
          <sqf:title>Merge lists into one</sqf:title>
        </sqf:description>
        <sqf:add position="last-child">
          <xsl:apply-templates mode="copyExceptClass" select="following-sibling::element()[1]/node()"/>
        </sqf:add>
        <sqf:delete match="following-sibling::element()[1]"/>
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
  
  
  <sch:pattern>
    <!-- Image without any kind of reference -->
    <sch:rule context="*[contains(@class, ' topic/image ')]">
      <sch:report test="not(@href) and not(@keyref) and not(@conref) and not(@conkeyref)" sqf:fix="add_href add_keyref add_conref add_conkeyref"> Image without
        a reference. </sch:report>
      
      <sqf:fix id="add_href">
        <sqf:description>
          <sqf:title>Add @href attribute</sqf:title>
        </sqf:description>
        <sqf:add node-type="attribute" target="href"/>
      </sqf:fix>
      
      <sqf:fix id="add_keyref">
        <sqf:description>
          <sqf:title>Add @keyref attribute</sqf:title>
        </sqf:description>
        <sqf:add node-type="attribute" target="keyref"/>
      </sqf:fix>
      
      <sqf:fix id="add_conref">
        <sqf:description>
          <sqf:title>Add @conref attribute</sqf:title>
        </sqf:description>
        <sqf:add node-type="attribute" target="conref"/>
      </sqf:fix>
      
      <sqf:fix id="add_conkeyref">
        <sqf:description>
          <sqf:title>Add @conkeyref attribute</sqf:title>
        </sqf:description>
        <sqf:add node-type="attribute" target="conkeyref"/>
      </sqf:fix>
    </sch:rule>
  </sch:pattern>
</sch:schema>
