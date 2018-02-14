<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xml:lang="en">
 <sch:pattern>
 <sch:rule context="dog">
     <sch:assert test="bone" sqf:fix="addBone">
        A dog should have a bone
     </sch:assert>
         
         <sqf:fix id="addBone">
             <sqf:description>
                 <sqf:title ref="sample.dog.addBone.title">Add a bone</sqf:title>
                 <sqf:p ref="sample.dog.addBone.p">The dog will get a bone.</sqf:p>
             </sqf:description>
             <sqf:add node-type="element" target="bone"/>
         </sqf:fix>
     </sch:rule>
 </sch:pattern>   
</sch:schema>