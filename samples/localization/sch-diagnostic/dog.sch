<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xml:lang="en">
    <sch:pattern>
        <sch:rule context="dog">
            <sch:assert test="bone" sqf:fix="addBone"> A dog should have a bone </sch:assert>

            <sqf:fix id="addBone">
                <sqf:description>
                    <sqf:title ref="sample.dog.addBone.title_de sample.dog.addBone.title_fr">Add a bone</sqf:title>
                    <sqf:p ref="sample.dog.addBone.p_de sample.dog.addBone.p_fr">The dog will get a bone.</sqf:p>
                </sqf:description>
                <sqf:add node-type="element" target="bone"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic id="sample.dog.addBone.title_de" xml:lang="de">Füge einen Knochen hinzu</sch:diagnostic>
        <sch:diagnostic id="sample.dog.addBone.p_de" xml:lang="de">Der Hund wird einen Knochen erhalten.</sch:diagnostic>
        
        <sch:diagnostic id="sample.dog.addBone.title_fr" xml:lang="fr">Ajouter un os</sch:diagnostic>
        <sch:diagnostic id="sample.dog.addBone.p_fr" xml:lang="fr">Le chien aura un os.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
