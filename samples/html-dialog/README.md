# HTML Dialog

This sample if just meant as a minimal sample how to use the Saxon extension instruction <gui:html-dialog> from within a quick fix. 

## Special Preconditions
To make this sample work the following preconditions need to be met:
1. XSLT Processor
The processing of the XSLT code within the quick fix needs to be processed by Saxon EE

2. Saxon Configuration
The extension namespace "http://www.dita-semia.org/xslt-gui" needs to be bound to the java class org.DitaSemia.XsltGui.SaxonFactory.
This can be done using the configuration file saxon-xsltgui-config.xml.

3. External Java Library
The java library DitaSemiaXsltGui.jar needs to be within the class path of Saxon. The file can be downloaded from https://github.com/dita-semia/XsltGui.

When using the oXygen project html-dialog-sch.xpr or sqf-samples.xpr the configuration has already been set in the project settings.
Still the jar file needs to be put to the oxygen lib folder. 
 