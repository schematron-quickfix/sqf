<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xml:lang="en">
    <sch:pattern>
        <sch:rule context="dog">
            <sch:let name="name" value="@name"/>
            <sch:let name="otherDogs" value="../dog[@name/tokenize(., '\s')[1] = $name/tokenize(., '\s')[1]]"/>
            <sch:let name="number" value="count($otherDogs) + 1"/>
            <sch:let name="newName" value="concat(@name, ' ', $number)"/>
            <sch:report test="../dog[@name = $name]" sqf:fix="addSuffix"> You should not have two dogs with the same name! </sch:report>

            <sqf:fix id="addSuffix">
                <sqf:description>
                    <sqf:title ref="sample.dog.addBone.title_de sample.dog.addBone.title_fr">Call the dog <sch:value-of select="$newName"/></sqf:title>
                    <sqf:p ref="sample.dog.addBone.p_de sample.dog.addBone.p_fr">The dog will still have the name <sch:value-of select="$name/tokenize(., '\s')[1]"/> but now with the suffix " <sch:value-of select="$number"/>".</sqf:p>
                </sqf:description>
                <sqf:replace match="@name" node-type="attribute" target="name" select="$newName"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic id="sample.dog.addBone.title_de" xml:lang="de">Nenne den Hund <sch:value-of select="$newName"/></sch:diagnostic>
        <sch:diagnostic id="sample.dog.addBone.p_de" xml:lang="de">Der Hund wird weiterhin <sch:value-of select="$name/tokenize(., '\s')[1]"/> heißen, nun aber mit dem Zusatz " <sch:value-of select="$number"/>".</sch:diagnostic>

        <sch:diagnostic id="sample.dog.addBone.title_fr" xml:lang="fr">Appelle le chien <sch:value-of select="$newName"/></sch:diagnostic>
        <sch:diagnostic id="sample.dog.addBone.p_fr" xml:lang="fr">Le chien portera toujours le nom de <sch:value-of select="$name/tokenize(., '\s')[1]"/> mais maintenant avec le suffixe " <sch:value-of select="$number"/>".</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
