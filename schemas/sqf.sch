<?xml version="1.0" encoding="UTF-8"?>

<!--  
    Copyright (c) 2014 Nico Kutscherauer
        
    This file is part of Escali Schematron.
    
    Escali Schematron is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    Escali Schematron is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with Escali Schematron.  If not, see http://www.gnu.org/licenses/gpl-3.0.
    
    -->

<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2" see="http://www.schematron-quickfix.com/quickFix/reference.html" xml:lang="en">
    <ns uri="http://purl.oclc.org/dsdl/schematron" prefix="sch"/>
    <ns uri="http://www.schematron-quickfix.com/validator/process" prefix="sqf"/>

    <pattern>
        <title>Query binding</title>
        <rule context="sch:schema">
            <assert test="not(namespace::sqf) or @queryBinding = 'xslt2'" sqf:fix="setQueryBinding"> Schematron Quick Fixes are only available within Schematron schemas based on XSLT 2.0.</assert>

            <sqf:fix id="setQueryBinding" role="replace">
                <sqf:description>
                    <sqf:title>Set @queryBinding attribute value to 'xslt2'</sqf:title>
                    <sqf:p>The quick fixes support works only with 'xslt2' query binding. So, the @queryBinding attribute value must be set to 'xslt2'.</sqf:p>
                </sqf:description>
                <sqf:add node-type="attribute" target="queryBinding" select="'xslt2'"/>
            </sqf:fix>
        </rule>
    </pattern>

    <pattern>
        <title>Correct Embedding</title>
        <rule context="sch:*/sqf:fixes">
            <let name="fixes" value="."/>
            <assert test="parent::sch:schema" sqf:fix="move delete unwrap moveAfter">The <name/> must be inserted just inside of the sch:schema element.</assert>
            <sqf:fix id="move">
                <sqf:description>
                    <sqf:title>Move the element sqf:fixes as the last child of schema</sqf:title>
                    <sqf:p>The sqf:fixes element was misplaced. The correct place is as a child element of the root element schema.</sqf:p>
                    <sqf:p>The sqf:fixes element will be moved at the end of the content of the schema element.</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="/sch:schema" position="last-child">
                    <xsl:copy-of select="$fixes"/>
                </sqf:add>
            </sqf:fix>
            <sqf:fix id="unwrap" use-when="parent::sch:rule">
                <sqf:description>
                    <sqf:title>Unwrap the sqf:fixes element</sqf:title>
                    <sqf:p>The sqf:fixes elements is misplaced in the Schematron rule.</sqf:p>
                    <sqf:p>One solution is to replace the container element sqf:fixes by its content.</sqf:p>
                </sqf:description>
                <sqf:replace select="node()"/>
            </sqf:fix>
            <sqf:fix id="moveAfter" use-when="parent::*/parent::sch:schema">
                <sqf:description>
                    <sqf:title>Move the element sqf:fixes after its parent element.</sqf:title>
                    <sqf:p>The sqf:fixes elements is misplaced inside of the <name path="parent::*"/> element.</sqf:p>
                    <sqf:p>It will be moved after the <name path="parent::*"/> element.</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="parent::*" position="after">
                    <xsl:copy-of select="$fixes"/>
                </sqf:add>
            </sqf:fix>
        </rule>
        <rule context="sch:*/sqf:fix | sch:*/sqf:group">
            <let name="fixOrGroup" value="."/>
            <let name="corr" value="//sch:rule[sch:*/@sqf:fix/tokenize(., '\s+') = $fixOrGroup/@id]"/>
            <assert test="parent::sch:rule" sqf:fix="wrap delete moveToTopLevel moveToRule moveToCorr">The <name/> element must be inserted just inside of a sch:rule element.</assert>
            <let name="desc" value="
                    if (name() = 'sqf:group') then
                        ('QuickFix group')
                    else
                        ('QuickFix')"/>
            <sqf:fix id="wrap" use-when="parent::sch:schema">
                <sqf:description>
                    <sqf:title>Wrap the <name/> element into a sqf:fixes container.</sqf:title>
                    <sqf:p>Top-level <name/> elements are not permitted.</sqf:p>
                    <sqf:p>Global <value-of select="$desc"/> should be contained in a sqf:fixes element.</sqf:p>
                    <sqf:p>The sqf:fixes container will be created around the <name/> element.</sqf:p>
                </sqf:description>
                <sqf:replace target="sqf:fixes" node-type="element">
                    <xsl:copy-of select="$fixOrGroup" copy-namespaces="no"/>
                </sqf:replace>
            </sqf:fix>
            <sqf:fix id="moveToRule" use-when="ancestor::sch:rule">
                <sqf:description>
                    <sqf:title>Move the <name/> element into the surrounding sch:rule element.</sqf:title>
                    <sqf:p>It is not allowed that the <name path="parent::*"/> element contains a <name/> element.</sqf:p>
                    <sqf:p>The <name/> element will be moved to the ancestor (surrounding) sch:rule element. It will be inserted on the next allowed position.</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="ancestor::*[parent::sch:rule]" position="after">
                    <xsl:copy-of select="$fixOrGroup" copy-namespaces="no"/>
                </sqf:add>
            </sqf:fix>
            <sqf:fix id="moveToTopLevel">
                <sqf:description>
                    <sqf:title>Change the <value-of select="$desc"/> to a global <value-of select="$desc"/>.</sqf:title>
                    <sqf:p>The <name/> element was misplaced. This fix will change this <value-of select="$desc"/> to a global <value-of select="$desc"/>.</sqf:p>
                    <sqf:p>Global <value-of select="$desc"/> are stored into the top level element sqf:fixes, so the <name/> element will be moved into it. If no sqf:fixes element is created yet, it will be created automatically.</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="/sch:schema/sqf:fixes[1]" position="last-child">
                    <xsl:copy-of select="$fixOrGroup" copy-namespaces="no"/>
                </sqf:add>
                <sqf:add match="/sch:schema" position="last-child" target="sqf:fixes" node-type="element" select="$fixOrGroup" use-when="not(/sch:schema/sqf:fixes)"/>
            </sqf:fix>
            <sqf:fix id="moveToCorr" use-when="count($corr) = 1">
                <sqf:description>
                    <sqf:title>Move the <name/> element to the rule, where it was used.</sqf:title>
                    <sqf:p>The <name/> element was misplaced but was referenced inside of a sch:rule element.</sqf:p>
                    <sqf:p>This fix will be move the <name/> element at the end of the sch:rule element, where it was referenced.</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="$corr" position="last-child" select="$fixOrGroup"/>
            </sqf:fix>
        </rule>
        <rule context="sch:*/sqf:*">
            <report test="true()" sqf:fix="delete">The <name/> element is not allowed inside of the element <name path="parent::node()"/>.</report>
        </rule>
        <rule context="sch:assert | sch:report">
            <let name="missplaced" value="@sqf:* except (@sqf:fix | @sqf:default-fix)"/>
            <let name="similarToDefaultFix" value="$missplaced[matches(name(), 'default', 'i')][1]"/>
            <let name="similarToFix" value="($missplaced except $similarToDefaultFix)[matches(name(), 'fix', 'i')][1]"/>
            <report test="$missplaced" sqf:fix="deleteAtts renameFixAttr renameDefault">The <value-of select="string-join($missplaced/name(), ', ')"/> attribute(s) is/are not allowed for the element <name/>.</report>
            <sqf:fix id="deleteAtts">
                <sqf:description>
                    <sqf:title>Delete all misplaced attributes.</sqf:title>
                    <sqf:p>The attributes in the SQF namespaces was misplaced for the element <name/>.</sqf:p>
                    <sqf:p>The only permitted attributes for the element <name/> are sqf:fix and sqf:default-fix.</sqf:p>
                    <sqf:p>All misplaced attributes will be deleted.</sqf:p>
                </sqf:description>
                <sqf:delete match="@sqf:* except (@sqf:fix | @sqf:default-fix)"/>
            </sqf:fix>
            <sqf:fix id="renameFixAttr" use-when="$similarToFix and not(@sqf:fix)">
                <sqf:description>
                    <sqf:title>Rename the <name path="$similarToFix"/> attribute to sqf:fix.</sqf:title>
                </sqf:description>
                <sqf:replace match="$similarToFix" target="sqf:fix" node-type="attribute">
                    <value-of select="."/>
                </sqf:replace>
            </sqf:fix>
            <sqf:fix id="renameDefault" use-when="$similarToDefaultFix and not(@sqf:default-fix)">
                <sqf:description>
                    <sqf:title>Rename the <name path="$similarToDefaultFix"/> attribute to sqf:default-fix.</sqf:title>
                </sqf:description>
                <sqf:replace match="$similarToDefaultFix" target="sqf:default-fix" node-type="attribute">
                    <value-of select="."/>
                </sqf:replace>
            </sqf:fix>
        </rule>
        <rule context="sch:*[@sqf:*]">
            <report test="true()" sqf:fix="deleteAtts">The <value-of select="string-join(@sqf:*/name(), ', ')"/> attribute(s) is/are not allowed for the element <name/>.</report>
            <sqf:fix id="deleteAtts">
                <sqf:description>
                    <sqf:title>Delete the misplaced <name/> element.</sqf:title>
                    <sqf:p>The <name/> element was misplaced.</sqf:p>
                    <sqf:p>Local QuickFixes or QuickFix groups should be contained in a sch:rule element.</sqf:p>
                    <sqf:p>Global QuickFixes or QuickFix groups should be contained in a top-level element sqf:fixes.</sqf:p>
                    <sqf:p>The misplaced <name/> element will be deleted.</sqf:p>
                </sqf:description>
                <sqf:delete match="@sqf:*"/>
            </sqf:fix>
        </rule>
    </pattern>
    <pattern>
        <title>Fix references</title>
        <rule context="sch:assert[@sqf:fix] | sch:report[@sqf:fix]">
            <let name="fixes" value="tokenize(@sqf:fix, '\s')"/>
            <let name="availableFixIds" value="sqf:getAvailableFixOrGroups(ancestor::sch:rule)/@id"/>
            <let name="notAvailableFixes" value="$fixes[not(. = $availableFixIds)]"/>
            <report test="count($notAvailableFixes) gt 0" see="http://www.schematron-quickfix.com/quickFix/reference.html#messageAttributes_fix" sqf:fix="deleteRef createLocal createGlobal">The fix(es) <value-of select="string-join($notAvailableFixes, ', ')"/> are not available in this rule.</report>

            <sqf:fix id="deleteRef">
                <sqf:description>
                    <sqf:title>Delete the references</sqf:title>
                </sqf:description>
                <sqf:replace match="@sqf:fix" target="sqf:fix" node-type="attribute" select="string-join($fixes[. = $availableFixIds], ' ')" use-when="$fixes[. = $availableFixIds]"/>
                <sqf:delete match="@sqf:fix" use-when="not($fixes[. = $availableFixIds])"/>
                <sqf:delete match="@sqf:default-fix" use-when="@sqf:default-fix = $notAvailableFixes"/>
            </sqf:fix>
            <sqf:fix id="createLocal">
                <sqf:description>
                    <sqf:title>Create new local QuickFixes</sqf:title>
                </sqf:description>
                <sqf:call-fix ref="createFix">
                    <sqf:with-param name="ids" select="$notAvailableFixes"/>
                    <sqf:with-param name="global" select="false()"/>
                </sqf:call-fix>
            </sqf:fix>
            <sqf:fix id="createGlobal">
                <sqf:description>
                    <sqf:title>Create new global QuickFixes</sqf:title>
                </sqf:description>
                <sqf:call-fix ref="createFix">
                    <sqf:with-param name="ids" select="$notAvailableFixes"/>
                    <sqf:with-param name="global" select="true()"/>
                </sqf:call-fix>
            </sqf:fix>
        </rule>

        <rule context="sch:rule/sqf:fix | sch:rule/sqf:group">
            <let name="id" value="@id"/>
            <let name="asserts" value="../(sch:assert | sch:report)"/>
            <let name="fixRefs" value="
                    $asserts/@sqf:fix/tokenize(., '\s'),
                    ../sqf:fix/sqf:call-fix/@ref"/>
            <let name="assertCount" value="count($asserts)"/>
            <assert test="$fixRefs = $id" role="warn" sqf:fix="add delete createAssert createReport">The <name/> element is not used by an assert or a report inside of this rule.</assert>
            <sqf:fix id="createAssert">
                <sqf:description>
                    <sqf:title>Create a new assert element</sqf:title>
                </sqf:description>
                <sqf:add position="before" target="sch:assert" node-type="element">
                    <xsl:attribute name="test"/>
                    <xsl:attribute name="sqf:fix" select="$id"/>
                    <xsl:text>Error message</xsl:text>
                </sqf:add>
            </sqf:fix>
            <sqf:fix id="createReport">
                <sqf:description>
                    <sqf:title>Create a new report element</sqf:title>
                </sqf:description>
                <sqf:add position="before" target="sch:report" node-type="element">
                    <xsl:attribute name="test"/>
                    <xsl:attribute name="sqf:fix" select="$id"/>
                    <xsl:text>Error message</xsl:text>
                </sqf:add>
            </sqf:fix>
            <sqf:group id="add">
                <sqf:fix id="add1" use-when="$assertCount ge 1 and $assertCount le 3">
                    <sqf:description>
                        <sqf:title>Add a reference to the first of the assert/report elements.</sqf:title>
                    </sqf:description>
                    <sqf:add match="$asserts[1]" target="sqf:fix" node-type="attribute" select="
                            string-join((@sqf:fix,
                            $id), ' ')"/>
                </sqf:fix>
                <sqf:fix id="add2" use-when="$assertCount ge 2 and $assertCount le 3">
                    <sqf:description>
                        <sqf:title>Add a reference to the second of the assert/report elements.</sqf:title>
                    </sqf:description>
                    <sqf:add match="$asserts[2]" target="sqf:fix" node-type="attribute" select="
                            string-join((@sqf:fix,
                            $id), ' ')"/>
                </sqf:fix>
                <sqf:fix id="add3" use-when="$assertCount ge 3 and $assertCount le 3">
                    <sqf:description>
                        <sqf:title>Add a reference to the third of the assert/report elements.</sqf:title>
                    </sqf:description>
                    <sqf:add match="$asserts[3]" target="sqf:fix" node-type="attribute" select="
                            string-join((@sqf:fix,
                            $id), ' ')"/>
                </sqf:fix>
                <sqf:fix id="addAll" use-when="$assertCount ge 2">
                    <sqf:description>
                        <sqf:title>Add references to all assert/report elements.</sqf:title>
                    </sqf:description>
                    <sqf:add match="$asserts" target="sqf:fix" node-type="attribute" select="
                            string-join((@sqf:fix,
                            $id), ' ')"/>
                </sqf:fix>
                <sqf:fix id="addPrec" use-when="preceding-sibling::*[1]/(self::sch:assert | self::sch:report)">
                    <sqf:description>
                        <sqf:title>Add to the first preceding assert/report element.</sqf:title>
                    </sqf:description>
                    <sqf:add match="preceding-sibling::*[1]/(self::sch:assert | self::sch:report)" target="sqf:fix" node-type="attribute" select="
                            string-join((@sqf:fix,
                            $id), ' ')"/>
                </sqf:fix>
            </sqf:group>
        </rule>
    </pattern>
    <pattern>
        <title>QuickFix IDs</title>
        <rule context="sch:rule//sqf:fix | sch:rule/sqf:group | sch:schema/sqf:fixes//sqf:fix | sch:schema/sqf:fixes/sqf:group">
            <let name="anc" value="ancestor::sch:rule | ancestor::sqf:fixes"/>
            <let name="otherFix" value="$anc//(sqf:fix | sqf:group) except ."/>
            <let name="id" value="@id"/>
            <report test="$otherFix[@id = $id][. &lt;&lt; current()]" sqf:fix="delete renameFix">This ID is doubled in the <name path="$anc"/> element.</report>

            <sqf:fix id="renameFix">
                <sqf:description>
                    <sqf:title>Make the ID unique.</sqf:title>
                </sqf:description>
                <let name="idx" value="
                        ((1 to count($otherFix))[not(some $f in $otherFix
                            satisfies $f/@id = concat($id, '_', .))])[1]"/>
                <sqf:replace match="@id" target="id" node-type="attribute" select="concat(., '_', $idx)"/>
            </sqf:fix>
        </rule>
    </pattern>
    <pattern>
        <title>Default fix</title>
        <rule context="sch:assert[@sqf:default-fix] | sch:report[@sqf:default-fix]">
            <let name="defaultFix" value="@sqf:default-fix"/>
            <let name="fixes" value="tokenize(@sqf:fix, '\s')"/>
            <let name="availableFixIds" value="sqf:getAvailableFixOrGroups(ancestor::sch:rule)/@id"/>
            <assert test="$fixes[. = $defaultFix]" see="http://www.schematron-quickfix.com/quickFix/reference.html#messageAttributes_default-fix" sqf:fix="createLocal addReference deleteAttr">The default fix "<value-of select="$defaultFix"/>" is not referred by the sqf:fix attribute.</assert>
            <sqf:fix id="createLocal" use-when="not($availableFixIds = $defaultFix)">
                <sqf:description>
                    <sqf:title>Create new local QuickFixes</sqf:title>
                </sqf:description>
                <sqf:call-fix ref="createFix">
                    <sqf:with-param name="ids" select="$defaultFix"/>
                    <sqf:with-param name="global" select="false()"/>
                </sqf:call-fix>
            </sqf:fix>
            <sqf:fix id="addReference">
                <sqf:description>
                    <sqf:title>add reference</sqf:title>
                </sqf:description>
                <sqf:add match="." target="sqf:fix" node-type="attribute" select="
                        string-join((@sqf:fix,
                        $defaultFix), ' ')"/>
            </sqf:fix>
            <sqf:fix id="deleteAttr">
                <sqf:description>
                    <sqf:title>Delete the sqf:default-fix attribute</sqf:title>
                </sqf:description>
                <sqf:delete match="@sqf:default-fix"/>
            </sqf:fix>
        </rule>
    </pattern>
    <pattern>
        <title>Activity elements</title>
        <rule context="sqf:add[@select] | sqf:replace[@select]">
            <report test="* or normalize-space(.) != ''" see="http://www.schematron-quickfix.com/quickFix/reference.html#activityManipulate_select" sqf:fix="contentOrSelect">If the select attribute is setted the <name/> element should be empty.</report>


        </rule>
    </pattern>
    <pattern>
        <title>Activity elements 2</title>
        <rule context="sqf:add[@node-type = 'attribute']">
            <assert test="not(@position)" see="http://www.schematron-quickfix.com/quickFix/reference.html#add_position" sqf:fix="set.node-type deletePosition" sqf:default-fix="deletePosition">If the node-type attribute has the value "attribute" the position attribute should not be set.</assert>

            <sqf:fix id="deletePosition">
                <sqf:description>
                    <sqf:title>Delete the position attribute.</sqf:title>
                </sqf:description>
                <sqf:delete match="@position"/>
            </sqf:fix>
        </rule>
        <rule context="sqf:add[@node-type != 'comment'] | sqf:replace[@node-type != 'comment']" role="error">
            <assert test="@target" see="http://www.schematron-quickfix.com/quickFix/reference.html#activityManipulate_node-type" sqf:fix="set.node-type.comment set.node-type.delete addTarget">The attribute target has to be set if the node-type attribute has not the value "comment".</assert>

            <sqf:fix id="addTarget">
                <let name="target" value="concat(@node-type, '-name')"/>
                <sqf:description>
                    <sqf:title>Adds a target attribute with the value <value-of select="$target"/></sqf:title>
                </sqf:description>
                <sqf:add target="target" node-type="attribute" select="$target"/>
            </sqf:fix>
        </rule>
        <rule context="sqf:add[@target] | sqf:replace[@target]" role="fatal">
            <assert test="@node-type" see="http://www.schematron-quickfix.com/quickFix/reference.html#activityManipulate_target" sqf:fix="set.node-type deleteTarget">The attribute node-type is required if the target attribute has been set.</assert>
            <report test="@node-type='comment'" role="warn" sqf:fix="set.node-type deleteTarget">The attribute target is useless if the node-type attribute has the value comment.</report>

            <sqf:fix id="deleteTarget">
                <sqf:description>
                    <sqf:title>Delete the target attribute</sqf:title>
                </sqf:description>
                <sqf:delete match="@target"/>
            </sqf:fix>
        </rule>
    </pattern>

    <pattern>
        <title>Generic fixes</title>
        <rule context="sqf:call-fix">
            <let name="ref" value="@ref"/>
            <let name="ancFix" value="ancestor::sqf:fix"/>
            <let name="availableFixIds" value="sqf:getAvailableFixOrGroups(.)/@id"/>

            <assert test="$ref = $availableFixIds" see="http://www.schematron-quickfix.com/quickFix/reference.html#sqf:call-fix" sqf:fix="createLocal createGlobal">The QuickFix with the id <value-of select="$ref"/> is not available in this rule.</assert>
            <report test="$ancFix/@id = $ref" see="http://www.schematron-quickfix.com/quickFix/reference.html#sqf:call-fix" sqf:fix="delete renameFix">The fix should not call its self. It will produce an endless loop.</report>


            <sqf:fix id="renameFix">
                <sqf:description>
                    <sqf:title>Make the ID unique.</sqf:title>
                </sqf:description>
                <sqf:replace match="$ancFix/@id" target="id" node-type="attribute" select="concat(., '_', generate-id())"/>
            </sqf:fix>

            <sqf:fix id="createLocal">
                <sqf:description>
                    <sqf:title>Create new local QuickFixes</sqf:title>
                </sqf:description>
                <sqf:call-fix ref="createFix">
                    <sqf:with-param name="ids" select="$ref"/>
                    <sqf:with-param name="global" select="false()"/>
                    <sqf:with-param name="params" select="./sqf:with-param/@name"/>
                </sqf:call-fix>
            </sqf:fix>
            <sqf:fix id="createGlobal">
                <sqf:description>
                    <sqf:title>Create new global QuickFixes</sqf:title>
                </sqf:description>
                <sqf:call-fix ref="createFix">
                    <sqf:with-param name="ids" select="$ref"/>
                    <sqf:with-param name="global" select="true()"/>
                    <sqf:with-param name="params" select="./sqf:with-param/@name"/>
                </sqf:call-fix>
            </sqf:fix>

        </rule>
        <rule context="sqf:with-param">
            <let name="paramName" value="@name"/>
            <let name="refFixId" value="../@ref"/>
            <let name="localRefFix" value="sqf:getAvailableFixOrGroups(., $LOCAL_ONLY)[@id = $refFixId]"/>
            <let name="refFix" value="
                    if ($localRefFix)
                    then
                        ($localRefFix)
                    else
                        (sqf:getAvailableFixOrGroups(., $GLOBAL_ONLY)[@id = $refFixId])"/>

            <assert test="$refFix/sqf:param[@name = $paramName]" see="http://www.schematron-quickfix.com/quickFix/reference.html#sqf:with-param" sqf:fix="addParam delete">The called QuickFix has no parameter with the name <value-of select="$paramName"/>.</assert>

            <report test="@select and node()" see="http://www.schematron-quickfix.com/quickFix/reference.html#with-param_select" sqf:fix="contentOrSelect">If the select attribute is setted the <name/> element should be empty.</report>

            <sqf:fix id="addParam">
                <sqf:description>
                    <sqf:title>Add a parameter to the referred QuickFix (do not use in oXygen 17)</sqf:title>
                </sqf:description>
                <sqf:add match="$refFix" target="sqf:param" node-type="element" position="first-child">
                    <xsl:attribute name="name" select="$paramName"/>
                </sqf:add>
            </sqf:fix>


        </rule>
        <rule context="sqf:param[@abstract = 'true']">
            <let name="forbiddenAttr" value="
                    @* except (@abstract,
                    @name)"/>
            <report test="$forbiddenAttr" sqf:fix="deleteAttr deleteAbstract">The attributes <value-of select="
                        string-join(for $a in $forbiddenAttr
                        return
                            name($a), ', ')"/> should not be set for abstract parameters.</report>
            <sqf:fix id="deleteAttr">
                <sqf:description>
                    <sqf:title>Delete all forbidden attributes.</sqf:title>
                </sqf:description>
                <sqf:delete match="$forbiddenAttr"/>
            </sqf:fix>
            <sqf:fix id="deleteAbstract">
                <sqf:description>
                    <sqf:title>Delete the abstract attribute.</sqf:title>
                </sqf:description>
                <sqf:delete match="@abstract"/>
            </sqf:fix>
        </rule>
    </pattern>

    <pattern>
        <title>Descriptions</title>
        <rule context="sqf:description">
            <report test="string-join(sqf:title/normalize-space(.), '') = ''" sqf:fix="delete deleteParent" role="warn">The description should have a title.</report>
            <sqf:fix id="delete" use-when="../sqf:description">
                <sqf:description>
                    <sqf:title>Delete the description element</sqf:title>
                </sqf:description>
                <sqf:delete/>
            </sqf:fix>
            <sqf:fix id="deleteParent" role="delete">
                <let name="parent" value="parent::*"/>
                <sqf:description>
                    <sqf:title>Delete the surrounding <name path="parent::*"/> element.</sqf:title>
                </sqf:description>
                <let name="pattern" value="concat('(^|\s)', $parent/@id, '(^|\s)')"/>
                <sqf:delete match="$parent"/>

                <sqf:replace match="$parent/ancestor::sch:rule/(sch:assert | sch:report)/@sqf:fix[matches(., $pattern)]" use-when="$parent/self::sqf:fix" target="sqf:fix" node-type="attribute" select="replace(., $pattern, ' ')"/>
            </sqf:fix>
        </rule>
    </pattern>

    <pattern>
        <title>Localisation tests</title>
        <let name="root" value="/"/>
        <let name="languages" value="distinct-values((//@xml:lang))"/>
        <let name="countLang" value="count($languages)"/>
        <rule context="/sch:schema" role="info">
            <report test="$countLang gt 0 and not(@xml:lang)" flag="location" sqf:fix="addXmlLang removeAllXmlLang">Localisation failed. If you use the xml:lang attribute you should set a root language.</report>
            <sqf:group id="addXmlLang">
                <sqf:fix id="addXmlLang_0" use-when="$countLang gt 3">
                    <sqf:description>
                        <sqf:title>Add a xml:lang attribute (with a empty value)</sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute"/>
                </sqf:fix>
                <sqf:fix id="addXmlLang_1" use-when="$countLang le 3 and $countLang ge 1">
                    <sqf:description>
                        <sqf:title>Add a xml:lang attribute with the value <value-of select="$languages[1]"/>.</sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute" select="$languages[1]"/>
                </sqf:fix>
                <sqf:fix id="addXmlLang_2" use-when="$countLang le 3 and $countLang ge 2">
                    <sqf:description>
                        <sqf:title>Add a xml:lang attribute with the value <value-of select="$languages[2]"/>.</sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute" select="$languages[2]"/>
                </sqf:fix>
                <sqf:fix id="addXmlLang_3" use-when="$countLang le 3 and $countLang ge 3">
                    <sqf:description>
                        <sqf:title>Add a xml:lang attribute with the value <value-of select="$languages[3]"/>.</sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute" select="$languages[3]"/>
                </sqf:fix>
            </sqf:group>
            <sqf:fix id="removeAllXmlLang">
                <sqf:description>
                    <sqf:title>Remove all xml:lang attributes in the whole schema.</sqf:title>
                </sqf:description>
                <sqf:delete match="//@xml:lang"/>
            </sqf:fix>
        </rule>
        <rule context="sch:assert | sch:report" role="info">
            <let name="msgLang" value="
                    if (node())
                    then
                        (sqf:getLang(.))
                    else
                        ()"/>
            <let name="diagnIDs" value="tokenize(@diagnostics, '\s')"/>
            <let name="usedLangs" value="
                    /sch:schema/sch:diagnostics/sch:diagnostic[@id = $diagnIDs]
                    /sqf:getLang(.),
                    $msgLang"/>
            <let name="id" value="
                    if (@id) then
                        @id
                    else
                        generate-id()"/>

            <let name="doubleLangCount" value="count($usedLangs) - count(distinct-values($usedLangs))"/>
            <let name="countMissLang" value="count($languages[not(. = $usedLangs)])"/>

            <report test="$countMissLang gt 0" sqf:fix="createMissingLang">Localisation failed. Missing a diagnostic or error message for the language(s) <value-of select="$languages[not(. = $usedLangs)]"/>.</report>
            <sqf:fix id="createMissingLang">
                <sqf:description>
                    <sqf:title>Create for each language a diagnostic</sqf:title>
                </sqf:description>

                <let name="diagnNew" value="
                        for $l in $languages[not(. = $usedLangs)]
                        return
                            concat($id, '_', $l)"/>

                <sqf:add match="/sch:schema/sch:diagnostics" use-when="/sch:schema/sch:diagnostics" position="last-child">
                    <xsl:for-each select="$languages[not(. = $usedLangs)]">
                        <xsl:element name="sch:diagnostic">
                            <xsl:attribute name="id" select="concat($id, '_', .)"/>
                            <xsl:attribute name="xml:lang" select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </sqf:add>
                <sqf:add match="/sch:schema" use-when="not(/sch:schema/sch:diagnostics)" position="last-child">
                    <xsl:element name="sch:diagnostics">
                        <xsl:for-each select="$languages[not(. = $usedLangs)]">
                            <xsl:element name="sch:diagnostic">
                                <xsl:attribute name="id" select="concat($id, '_', .)"/>
                                <xsl:attribute name="xml:lang" select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </sqf:add>
                <sqf:add match="@diagnostics" target="diagnostics" node-type="attribute" select="
                        string-join(($diagnIDs,
                        $diagnNew), ' ')"/>
            </sqf:fix>
        </rule>
        <rule context="sqf:*[sqf:description]" role="info">
            <let name="usedLangs" value="(sqf:description/sqf:getLang(.))"/>
            <report test="count($languages[not(. = $usedLangs)]) gt 0" sqf:fix="createMissingLang">Localisation failed. Missing a description for the language(s) <value-of select="$languages[not(. = $usedLangs)]"/>.</report>
            <sqf:fix id="createMissingLang">
                <sqf:description>
                    <sqf:title>Create for each missing language a new description</sqf:title>
                </sqf:description>
                <sqf:add match="sqf:description[last()]" position="after">
                    <let name="content" value="node()"/>
                    <xsl:for-each select="$languages[not(. = $usedLangs)]">
                        <xsl:element name="sqf:description">
                            <xsl:attribute name="xml:lang" select="."/>
                            <xsl:copy-of select="$content" copy-namespaces="no"/>
                        </xsl:element>
                    </xsl:for-each>
                </sqf:add>
            </sqf:fix>
        </rule>
        <rule context="sqf:description[preceding-sibling::sqf:description]">
            <let name="lang" value="sqf:getLang(.)"/>
            <report test="$lang = preceding-sibling::sqf:description/sqf:getLang(.)" sqf:fix="delete translate">Double description for the language <value-of select="$lang"/> and <name path="parent::*"/> element.</report>

            <let name="usedLangs" value="(../sqf:description/sqf:getLang(.))"/>
            <let name="missingLangs" value="$languages[not(. = $usedLangs)]"/>
            <sqf:group id="translate">
                <sqf:fix id="translate1" use-when="count($missingLangs) gt 0">
                    <let name="missingLang" value="$missingLangs[1]"/>
                    <sqf:description>
                        <sqf:title>Switch the language to <value-of select="$missingLang"/></sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute" select="$missingLang"/>
                </sqf:fix>
                <sqf:fix id="translate2" use-when="count($missingLangs) gt 0">
                    <let name="missingLang" value="$missingLangs[2]"/>
                    <sqf:description>
                        <sqf:title>Switch the language to <value-of select="$missingLang"/></sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute" select="$missingLang"/>
                </sqf:fix>
                <sqf:fix id="translate3" use-when="count($missingLangs) gt 0">
                    <let name="missingLang" value="$missingLangs[3]"/>
                    <sqf:description>
                        <sqf:title>Switch the language to <value-of select="$missingLang"/></sqf:title>
                    </sqf:description>
                    <sqf:add target="xml:lang" node-type="attribute" select="$missingLang"/>
                </sqf:fix>
            </sqf:group>
        </rule>
    </pattern>

    <!--  
    Functions
    -->
    <xsl:variable name="LOCAL_ONLY" select="'LOCAL_ONLY'" as="xs:string"/>
    <xsl:variable name="GLOBAL_ONLY" select="'GLOBAL_ONLY'" as="xs:string"/>
    <xsl:variable name="GLOBAL_AND_LOCAL" select="'GLOBAL_AND_LOCAL'" as="xs:string"/>

    <xsl:function name="sqf:getAvailableFixOrGroups" as="element()*">
        <xsl:param name="context" as="element()*"/>
        <xsl:sequence select="sqf:getAvailableFixOrGroups($context, $GLOBAL_AND_LOCAL)"/>
    </xsl:function>
    <xsl:function name="sqf:getAvailableFixOrGroups" as="element()*">
        <xsl:param name="context" as="element()*"/>
        <xsl:param name="localOrGlobal" as="xs:string"/>
        <xsl:variable name="rule" select="$context/ancestor-or-self::sch:rule"/>
        <xsl:variable name="local" select="
                if (not($localOrGlobal = $GLOBAL_ONLY))
                then
                    ($rule)
                else
                    ()"/>
        <xsl:variable name="global" select="
                if (not($localOrGlobal = $LOCAL_ONLY))
                then
                    (root($context)/sch:schema/sqf:fixes)
                else
                    ()"/>
        <xsl:variable name="availableFixes" select="
                $local/sqf:fix | $global/sqf:fix"/>
        <xsl:variable name="availableGroups" select="
                ($local/sqf:group | $global/sqf:group)/(. | ./sqf:fix)"/>
        <xsl:sequence select="
                $availableFixes,
                $availableGroups"/>
    </xsl:function>

    <xsl:function name="sqf:getLang" as="xs:string">
        <xsl:param name="node" as="node()"/>
        <xsl:variable name="lang" select="($node/ancestor-or-self::*/@xml:lang)[last()]"/>
        <xsl:value-of select="
                if ($lang) then
                    ($lang)
                else
                    ('#DEFAULT')"/>
    </xsl:function>

    <!--   
    Global fixes
    -->

    <sqf:fixes>
        <sqf:fix id="delete">
            <sqf:description>
                <sqf:title>Delete the <name/> element.</sqf:title>
                <sqf:p>The <name/> element was misplaced. This fix will delete it.</sqf:p>
            </sqf:description>
            <sqf:delete/>
        </sqf:fix>

        <sqf:group id="contentOrSelect">
            <sqf:fix id="deleteContent">
                <sqf:description>
                    <sqf:title>Delete the content of the <name/> element.</sqf:title>
                </sqf:description>
                <sqf:delete match="node()"/>
            </sqf:fix>

            <sqf:fix id="deleteSelectAtt">
                <sqf:description>
                    <sqf:title>Delete the select attribute</sqf:title>
                </sqf:description>
                <sqf:delete match="@select"/>
            </sqf:fix>
        </sqf:group>

        <sqf:fix id="createFix">
            <sqf:param name="ids" type="xs:string+" required="yes"/>
            <sqf:param name="global" type="xs:boolean" default="false()"/>
            <sqf:param name="params" type="xs:string*" default="()"/>
            <sqf:description>
                <sqf:title/>
            </sqf:description>
            <xsl:variable name="newFixes">
                <xsl:for-each select="$ids">
                    <xsl:element name="sqf:fix">
                        <xsl:attribute name="id" select="."/>
                        <xsl:for-each select="$params">
                            <xsl:element name="sqf:param">
                                <xsl:attribute name="name" select="."/>
                            </xsl:element>
                        </xsl:for-each>
                        <xsl:element name="sqf:description">
                            <xsl:element name="sqf:title"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:variable>

            <sqf:add match="ancestor-or-self::*[parent::sch:rule]" position="after" select="$newFixes" use-when="not($global)"/>

            <sqf:add match="/sch:schema/sqf:fixes" position="last-child" select="$newFixes" use-when="$global"/>
            <sqf:add match="/sch:schema" target="sqf:fixes" node-type="element" select="$newFixes" position="last-child" use-when="not(/sch:schema/sqf:fixes) and $global"/>



        </sqf:fix>



        <sqf:group id="set.node-type">
            <sqf:fix id="set.node-type.element" use-when="not(@node-type = 'element')">
                <sqf:description>
                    <sqf:title>Set node-type attribute to element.</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="node-type" select="'element'"/>
            </sqf:fix>
            <sqf:fix id="set.node-type.attribute" use-when="not(@node-type = 'attribute')">
                <sqf:description>
                    <sqf:title>Set node-type attribute to attribute.</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="node-type" select="'attribute'"/>
            </sqf:fix>
            <sqf:fix id="set.node-type.comment" use-when="not(@node-type = 'comment')">
                <sqf:description>
                    <sqf:title>Set node-type attribute to comment.</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="node-type" select="'comment'"/>
            </sqf:fix>
            <sqf:fix id="set.node-type.pi" use-when="not(@node-type = 'pi')">
                <sqf:description>
                    <sqf:title>Set node-type attribute to pi.</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="node-type" select="'pi'"/>
            </sqf:fix>
            <sqf:fix id="set.node-type.delete" use-when="not(@target) and @node-type">
                <sqf:description>
                    <sqf:title>Delete node-type </sqf:title>
                </sqf:description>
                <sqf:delete match="@node-type"/>
            </sqf:fix>
        </sqf:group>

    </sqf:fixes>
</schema>
