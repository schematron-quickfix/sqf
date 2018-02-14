<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xml:lang="en">
 <sch:pattern>
     <sch:rule context="dog">
         <sch:let name="name" value="@name"/>
         <sch:let name="otherDogs" value="../dog[@name/tokenize(., '\s')[1] = $name/tokenize(., '\s')[1]]"/>
         <sch:let name="number" value="count($otherDogs) + 1"/>
         <sch:let name="newName" value="concat(@name, ' ', $number)"/>
         <sch:report test="../dog[@name = $name]" sqf:fix="addSuffix">
            You should not have two dogs with the same name! 
         </sch:report>
         
         <sqf:fix id="addSuffix">
             <sqf:description>
                 <sqf:title ref="sample.dog.addBone.title">Call the dog <sch:value-of select="$newName"/></sqf:title>
                 <sqf:p ref="sample.dog.addBone.p">The dog will still have the name <sch:value-of select="$name/tokenize(., '\s')[1]"/> but now with the suffix " <sch:value-of select="$number"/>".</sqf:p>
             </sqf:description>
             <sqf:replace match="@name" node-type="attribute" target="name" select="$newName"/>
         </sqf:fix>
     </sch:rule>
 </sch:pattern>   
</sch:schema>